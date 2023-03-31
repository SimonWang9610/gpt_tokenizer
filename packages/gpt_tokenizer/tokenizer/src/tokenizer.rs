use std::collections::HashSet;
use std::thread;

use std::fs::File;
use std::io::{BufRead, BufReader};

use base64::decode;

use anyhow::{Ok, Result};

use flutter_rust_bridge::ffi::{RustOpaque, ZeroCopyBuffer};

use fancy_regex::Regex;

use rustc_hash::FxHashMap as HashMap;

fn _byte_pair_merge<T>(
    piece: &[u8],
    ranks: &HashMap<Vec<u8>, usize>,
    f: impl Fn(std::ops::Range<usize>) -> T,
) -> Vec<T> {
    // This is a vector of (start, rank).
    // The rank is of the byte pair starting at position start.
    // The rank of the last item in the vector is not a valid value.
    let mut parts: Vec<(usize, usize)> = (0..piece.len() + 1).map(|i| (i, usize::MAX)).collect();

    let get_rank = {
        #[inline(always)]
        |parts: &Vec<(usize, usize)>, start_idx: usize, skip: usize| {
            if (start_idx + skip + 2) < parts.len() {
                ranks
                    .get(&piece[parts[start_idx].0..parts[start_idx + skip + 2].0])
                    .copied()
            } else {
                None
            }
        }
    };

    // We look up the ranks once in the beginning and iteratively update
    // them during each merge, which reduces the number of rank lookups.
    for i in 0..parts.len() - 2 {
        match get_rank(&parts, i, 0) {
            Some(rank) => {
                // usize::MAX is a sentinel value and cannot be a valid rank
                debug_assert!(rank != usize::MAX);
                parts[i].1 = rank;
            }
            None => {
                continue;
            }
        };
    }

    // If you have n parts and m merges, this does O(mn) work.
    // We could do something with a heap and do O(m log n) work.
    // It is important to consider that n is often small (<100), and as such
    // the cache-locality benefits outweigh the algorithmic complexity downsides
    // of the `parts` vector data structure above.

    // Note that we hash bytes, not token pairs. As long as we train BPE the way we
    // currently do, this is equivalent. An easy way to break this would be to decouple
    // merge priority from token index or to prevent specific token merges.
    loop {
        if parts.len() == 1 {
            break;
        }

        // usize::MAX is a sentinel rank value allowing us to
        // take the min more quickly
        let mut min_rank: (usize, usize) = (usize::MAX, 0);
        for (i, &(_, rank)) in parts[..parts.len() - 1].iter().enumerate() {
            if rank < min_rank.0 {
                min_rank = (rank, i);
            }
        }

        if min_rank.0 != usize::MAX {
            let i = min_rank.1;

            // NOTE: We are about to remove parts[i + 1]. We do not do it
            // yet because there are cache-locality benefits to updating
            // parts[i] and parts[i-1] before removing, which could thrash
            // the cache. Thus, we update the rank calculation by skipping over
            // parts[i + 1], by invoking `get_rank!` with `skip = 1`.
            parts[i].1 = get_rank(&parts, i, 1).unwrap_or(usize::MAX);
            if i > 0 {
                parts[i - 1].1 = get_rank(&parts, i - 1, 1).unwrap_or(usize::MAX);
            }

            parts.remove(i + 1);
        } else {
            break;
        }
    }
    let mut out: Vec<T> = Vec::with_capacity(parts.len() - 1);
    for i in 0..parts.len() - 1 {
        out.push(f(parts[i].0..parts[i + 1].0));
    }
    out
}

fn byte_pair_encode(piece: &[u8], ranks: &HashMap<Vec<u8>, usize>) -> Vec<usize> {
    if piece.len() == 1 {
        return vec![ranks[piece]];
    }
    _byte_pair_merge(piece, ranks, |p| ranks[&piece[p.start..p.end]])
}

use std::num::NonZeroU64;
pub struct FakeThreadId(NonZeroU64);

fn hash_current_thread() -> usize {
    // It's easier to use unsafe than to use nightly. Rust has this nice u64 thread id counter
    // that works great for our use case of avoiding collisions in our array. Unfortunately,
    // it's private. However, there are only so many ways you can layout a u64, so just transmute
    // https://github.com/rust-lang/rust/issues/67939
    const _: [u8; 8] = [0; std::mem::size_of::<std::thread::ThreadId>()];
    const _: [u8; 8] = [0; std::mem::size_of::<FakeThreadId>()];
    let x = unsafe {
        std::mem::transmute::<std::thread::ThreadId, FakeThreadId>(thread::current().id()).0
    };
    u64::from(x) as usize
}

const MAX_NUM_THREADS: usize = 8;
pub struct CoreBPE {
    encoder: HashMap<Vec<u8>, usize>,
    special_tokens_encoder: HashMap<String, usize>,
    decoder: HashMap<usize, Vec<u8>>,
    special_tokens_decoder: HashMap<usize, Vec<u8>>,
    regex_tls: Vec<Regex>,
    special_regex_tls: Vec<Regex>,
}

impl CoreBPE {
    fn new(
        encoder: HashMap<Vec<u8>, usize>,
        special_tokens_encoder: HashMap<String, usize>,
        pattern: &str,
    ) -> Self {
        let regex =
            Regex::new(pattern).expect("Failed to compile regex. This is a bug. Please report it.");

        let special_regex = {
            let _parts = special_tokens_encoder
                .keys()
                .map(|s| fancy_regex::escape(s))
                .collect::<Vec<_>>();
            Regex::new(&_parts.join("|"))
                .expect("Failed to compile special token regex. This is a bug. Please report it.")
        };

        let decoder: HashMap<usize, Vec<u8>> =
            encoder.iter().map(|(k, v)| (*v, k.clone())).collect();

        assert!(encoder.len() == decoder.len());

        let special_tokens_decoder: HashMap<usize, Vec<u8>> = special_tokens_encoder
            .iter()
            .map(|(k, v)| (*v, k.as_bytes().to_vec()))
            .collect();

        CoreBPE {
            encoder,
            special_tokens_encoder,
            decoder,
            special_tokens_decoder,
            regex_tls: (0..MAX_NUM_THREADS).map(|_| regex.clone()).collect(),
            special_regex_tls: (0..MAX_NUM_THREADS)
                .map(|_| special_regex.clone())
                .collect(),
        }
    }

    fn _get_tl_regex(&self) -> &Regex {
        // See performance notes above for what this is about
        // It's also a little janky, please make a better version of it!
        // However, it's nice that this doesn't leak memory to short-lived threads
        &self.regex_tls[hash_current_thread() % MAX_NUM_THREADS]
    }

    fn _get_tl_special_regex(&self) -> &Regex {
        &self.special_regex_tls[hash_current_thread() % MAX_NUM_THREADS]
    }

    fn _decode_native(&self, tokens: &[usize]) -> Vec<u8> {
        let mut ret = Vec::with_capacity(tokens.len() * 2);
        for token in tokens {
            let token_bytes = self
                .decoder
                .get(token)
                .unwrap_or_else(|| &self.special_tokens_decoder[token]);
            ret.extend(token_bytes);
        }
        ret
    }

    fn _encode_ordinary_native(&self, text: &str) -> Vec<usize> {
        // This is the core of the encoding logic; the other functions in here
        // just make things complicated :-)
        let regex = self._get_tl_regex();
        let mut ret = vec![];
        for mat in regex.find_iter(text) {
            let piece = mat.unwrap().as_str().as_bytes();
            if let Some(token) = self.encoder.get(piece) {
                ret.push(*token);
                continue;
            }
            ret.extend(&byte_pair_encode(piece, &self.encoder));
        }
        ret
    }

    fn _encode_native(&self, text: &str, allowed_special: &HashSet<&str>) -> (Vec<usize>, usize) {
        let special_regex = self._get_tl_special_regex();
        let regex = self._get_tl_regex();
        let mut ret = vec![];

        let mut start = 0;
        let mut last_piece_token_len = 0;
        loop {
            let mut next_special;
            let mut start_find = start;
            loop {
                // Find the next allowed special token, if any
                next_special = special_regex.find_from_pos(text, start_find).unwrap();
                match next_special {
                    Some(m) => {
                        if allowed_special.contains(&text[m.start()..m.end()]) {
                            break;
                        }
                        start_find = m.start() + 1;
                    }
                    None => break,
                }
            }
            let end = next_special.map_or(text.len(), |m| m.start());

            // Okay, here we go, compare this logic to _encode_ordinary_native
            for mat in regex.find_iter(&text[start..end]) {
                let piece = mat.unwrap().as_str().as_bytes();
                if let Some(token) = self.encoder.get(piece) {
                    last_piece_token_len = 1;
                    ret.push(*token);
                    continue;
                }
                let tokens = byte_pair_encode(piece, &self.encoder);
                last_piece_token_len = tokens.len();
                ret.extend(&tokens);
            }

            match next_special {
                // And here we push the special token
                Some(m) => {
                    let piece = m.as_str();
                    let token = self.special_tokens_encoder[piece];
                    ret.push(token);
                    start = m.end();
                    last_piece_token_len = 0;
                }
                None => break,
            }
        }

        // last_piece_token_len is how many tokens came from the last regex split. This is used
        // for determining unstable tokens, since you can't merge across (stable) regex splits
        (ret, last_piece_token_len)
    }

    fn _encode_for_count(&self, text: &str, allowed_special: &HashSet<&str>) -> usize {
        let special_regex = self._get_tl_special_regex();
        let regex = self._get_tl_regex();

        let mut count = 0;

        let mut start = 0;
        loop {
            let mut next_special;
            let mut start_find = start;
            loop {
                // Find the next allowed special token, if any
                next_special = special_regex.find_from_pos(text, start_find).unwrap();
                match next_special {
                    Some(m) => {
                        if allowed_special.contains(&text[m.start()..m.end()]) {
                            break;
                        }
                        start_find = m.start() + 1;
                    }
                    None => break,
                }
            }
            let end = next_special.map_or(text.len(), |m| m.start());

            // Okay, here we go, compare this logic to _encode_ordinary_native
            for mat in regex.find_iter(&text[start..end]) {
                let piece = mat.unwrap().as_str().as_bytes();
                if let Some(_) = self.encoder.get(piece) {
                    count += 1;
                    continue;
                }
                let tokens = byte_pair_encode(piece, &self.encoder);
                count += tokens.len();
            }

            match next_special {
                // And here we push the special token
                Some(m) => {
                    count += 1;
                    start = m.end();
                }
                None => break,
            }
        }

        count
    }

    fn _increase_last_piece_token_len(
        &self,
        tokens: Vec<usize>,
        mut last_piece_token_len: usize,
    ) -> (Vec<usize>, usize) {
        {
            let token_is_all_space = |token| {
                self.decoder
                    .get(token)
                    .map(|token_bytes| {
                        token_bytes
                            .iter()
                            .rev()
                            .all(|&b| [b' ', b'\n', b'\t'].contains(&b))
                    })
                    .unwrap_or(false)
            };
            if last_piece_token_len > 0
                && token_is_all_space(&tokens[tokens.len() - last_piece_token_len])
            {
                while (last_piece_token_len < tokens.len())
                    && token_is_all_space(&tokens[tokens.len() - last_piece_token_len - 1])
                {
                    last_piece_token_len += 1;
                }
            }
        }
        debug_assert!(last_piece_token_len <= tokens.len());

        (tokens, last_piece_token_len)
    }
}
pub struct EncoderMapEntry {
    pub key: Vec<u8>,
    pub value: usize,
}

pub struct SpecialEncoderMapEntry {
    pub key: String,
    pub value: usize,
}

pub struct BPEWrapper {
    pub bpe: RustOpaque<CoreBPE>,
}

impl BPEWrapper {
    pub fn create(
        encoder_entries: Vec<EncoderMapEntry>,
        special_tokens_encoder_entries: Vec<SpecialEncoderMapEntry>,
        pattern: String,
    ) -> BPEWrapper {
        let special_tokens_encoder: HashMap<String, usize> = HashMap::from_iter(
            special_tokens_encoder_entries
                .into_iter()
                .map(|e| (e.key, e.value)),
        );

        let encoder: HashMap<Vec<u8>, usize> =
            HashMap::from_iter(encoder_entries.into_iter().map(|e| (e.key, e.value)));

        BPEWrapper {
            bpe: RustOpaque::new(CoreBPE::new(encoder, special_tokens_encoder, &pattern)),
        }
    }

    pub fn load(
        path: String,
        special_tokens_encoder_entries: Vec<SpecialEncoderMapEntry>,
        pattern: String,
    ) -> BPEWrapper {
        let special_tokens_encoder: HashMap<String, usize> = HashMap::from_iter(
            special_tokens_encoder_entries
                .into_iter()
                .map(|e| (e.key, e.value)),
        );

        let encoder: HashMap<Vec<u8>, usize> =
            HashMap::from_iter(read_lines(&path).into_iter().map(|e| (e.key, e.value)));

        BPEWrapper {
            bpe: RustOpaque::new(CoreBPE::new(encoder, special_tokens_encoder, &pattern)),
        }
    }
}

fn read_lines(filepath: &str) -> Vec<EncoderMapEntry> {
    let file = File::open(filepath).expect(format!("Unable to open file {}", filepath).as_str());
    let lines = BufReader::new(file).lines();

    let mut encoder_entries: Vec<EncoderMapEntry> = Vec::new();

    for line in lines {
        if let Result::Ok(line) = line {
            let split: Vec<&str> = line.split_whitespace().collect();
            let encoder_entry = EncoderMapEntry {
                key: decode(split[0]).unwrap(),
                value: split[1].parse::<usize>().unwrap(),
            };

            encoder_entries.push(encoder_entry);
        }
    }
    encoder_entries
}

fn cast_to_u32_vec(input: Vec<usize>) -> ZeroCopyBuffer<Vec<u32>> {
    ZeroCopyBuffer(input.into_iter().map(|x| x as u32).collect())
}

fn cast_to_u8_vec(v: Vec<usize>) -> ZeroCopyBuffer<Vec<u8>> {
    ZeroCopyBuffer(v.into_iter().map(|x| x as u8).collect())
}

fn cast_to_usize_vec(v: Vec<u32>) -> Vec<usize> {
    v.into_iter().map(|x| x as usize).collect()
}

impl BPEWrapper {
    pub fn encode_ordinary(&self, text: String) -> ZeroCopyBuffer<Vec<u32>> {
        let encoded = self.bpe._encode_ordinary_native(&text);
        cast_to_u32_vec(encoded)
    }

    pub fn encode(
        &self,
        text: String,
        allowed_special_entries: Vec<String>,
    ) -> ZeroCopyBuffer<Vec<u32>> {
        let allowed_special = allowed_special_entries.iter().map(|s| s.as_str()).collect();
        let encoded = self.bpe._encode_native(&text, &allowed_special).0;

        cast_to_u32_vec(encoded)
    }

    // pub fn encode_batch(
    //     &self,
    //     texts: Vec<String>,
    //     allowed_special_entries: Vec<String>,
    // ) -> Vec<ZeroCopyBuffer<Vec<u32>>> {
    //     let mut all_encoded: Vec<ZeroCopyBuffer<Vec<u32>>> = Vec::new();

    //     let allowed_special_entries = Arc::new(allowed_special_entries);

    //     let total = texts.len();

    //     let mut end = 0;

    //     while all_encoded.len() < total {
    //         for _ in 0..4 {
    //             if end < total {
    //                 let cloned_bpe = Arc::clone(&self.bpe);
    //                 let hash_set = HashSet::from_iter(
    //                     Arc::clone(&allowed_special_entries)
    //                         .iter()
    //                         .map(|s| s.as_str()),
    //                 );

    //                 let res =
    //                     _thread_executor(|| cloned_bpe._encode_native(&texts[end], &hash_set).0);
    //             }
    //         }
    //     }

    //     all_encoded
    // }

    pub fn count_token(&self, text: String, allowed_special_entries: Vec<String>) -> usize {
        let allowed_special = allowed_special_entries.iter().map(|s| s.as_str()).collect();
        self.bpe._encode_for_count(&text, &allowed_special)
    }

    pub fn encode_bytes(&self, bytes: Vec<u8>) -> ZeroCopyBuffer<Vec<u8>> {
        let tokens = match std::str::from_utf8(&bytes) {
            Result::Ok(text) => self.bpe._encode_ordinary_native(text),
            Err(e) => {
                let text = unsafe { std::str::from_utf8_unchecked(&bytes[..e.valid_up_to()]) };
                let (tokens, last_piece_token_len) = self.bpe._encode_native(text, &HashSet::new());
                let (mut tokens, last_piece_token_len) = self
                    .bpe
                    ._increase_last_piece_token_len(tokens, last_piece_token_len);
                if !tokens.is_empty() && last_piece_token_len > 0 {
                    // Lop off the tokens from the last piece and run BPE on the remaining bytes
                    // Somewhat niche, but this may not be correct if we'd have had a regex
                    // split between the valid UTF-8 and the invalid bytes, which is why this
                    // method is private
                    let mut unstable_bytes = self
                        .bpe
                        ._decode_native(&tokens[tokens.len() - last_piece_token_len..]);
                    unstable_bytes.extend_from_slice(&bytes[e.valid_up_to()..]);

                    tokens.truncate(tokens.len() - last_piece_token_len);
                    tokens.extend(byte_pair_encode(&unstable_bytes, &self.bpe.encoder));
                }
                tokens
            }
        };
        cast_to_u8_vec(tokens)
    }

    pub fn encode_single_token(&self, piece: Vec<u8>) -> Result<usize> {
        if let Some(token) = self.bpe.encoder.get(&piece).copied() {
            return Ok(token);
        }
        if let Result::Ok(piece_str) = std::str::from_utf8(&piece) {
            if let Some(token) = self.bpe.special_tokens_encoder.get(piece_str).copied() {
                return Ok(token);
            }
        }

        panic!("Piece not found in the vocabulary: {:?}", piece);
    }

    // pub fn encode_single_piece(&self, piece: Vec<u8>) -> ZeroCopyBuffer<Vec<u32>> {
    //     if let Some(token) = self.bpe.encoder.get(&piece) {
    //         return cast_to_u32_vec(vec![*token]);
    //     }
    //     cast_to_u32_vec(byte_pair_encode(&piece, &self.bpe.encoder))
    // }

    pub fn decode_bytes(&self, tokens: Vec<u32>) -> ZeroCopyBuffer<Vec<u8>> {
        let bytes = self.bpe._decode_native(&cast_to_usize_vec(tokens));
        ZeroCopyBuffer(bytes.into())
    }

    pub fn decode_single_token_bytes(&self, token: usize) -> ZeroCopyBuffer<Vec<u8>> {
        if let Some(bytes) = self.bpe.decoder.get(&token) {
            return ZeroCopyBuffer(bytes.to_owned());
        }
        if let Some(bytes) = self.bpe.special_tokens_decoder.get(&token) {
            return ZeroCopyBuffer(bytes.to_owned());
        }

        panic!("Token not found in the vocabulary: {:?}", token);
    }
}
