import 'dart:convert';
import 'dart:io';

import 'package:gpt_tokenizer/gpt_tokenizer.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:test/test.dart';

void main() async {
  const dylibPath = "../../target/debug/libgpt_tokenizer.dylib";

  final impl = loadLibraryFromPath(dylibPath);

  final map = await loadLocalTestFile();

  const pattern =
      r"(?i:'s|'t|'re|'ve|'m|'ll|'d)|[^\r\n\p{L}\p{N}]?\p{L}+|\p{N}{1,3}| ?[^\s\p{L}\p{N}]+[\r\n]*|\s*[\r\n]+|\s+(?!\S)|\s+";

  final specialTokens = {
    "<|endoftext|>": 100257,
    "<|fim_prefix|>": 100258,
    "<|fim_middle|>": 100259,
    "<|fim_suffix|>": 100260,
    "<|endofprompt|>": 100276,
  };

  final encoderEntries = map.entries
      .map((e) => EncoderMapEntry(key: e.key, value: e.value))
      .toList();

  final specialEncoderEntries = specialTokens.entries
      .map((e) => SpecialEncoderMapEntry(key: e.key, value: e.value))
      .toList();
  final bpe = await impl.createStaticMethodBpeWrapper(
    encoderEntries: encoderEntries,
    specialTokensEncoderEntries: specialEncoderEntries,
    pattern: pattern,
  );

  test("tokenizer encode", () async {
    const text = "Hello world!";

    final encoded =
        await bpe.encode(text: text, allowedSpecialEntries: const []);

    expect(encoded.length, 3);
  });

  test("tokenizer count", () async {
    const text = "Hello world!";

    final count =
        await bpe.countToken(text: text, allowedSpecialEntries: const []);

    expect(count, 3);
  });

  test("tokenizer decode", () async {
    const text = "Hello world!";

    final encoded =
        await bpe.encode(text: text, allowedSpecialEntries: const []);

    final decoded = await bpe.decodeBytes(tokens: encoded);

    expect(utf8.decode(decoded), text);
  });
}

GptTokenizerImpl loadLibraryFromPath(String path) {
  return loadTokenizerImpl(loadDylib(path));
}

Future<Map<Uint8List, int>> loadLocalTestFile() async {
  const path = '../../assets/cl100k_base.tiktoken';
  final file = File(path);

  final lines = await file.readAsLines();

  final map = <Uint8List, int>{};
  for (final line in lines) {
    final split = line.split(" ");
    final token = base64.decode(split[0]);
    final rank = int.parse(split[1]);

    map[token] = rank;
  }

  return map;
}
