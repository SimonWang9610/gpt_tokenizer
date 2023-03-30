import 'dart:convert';
import 'dart:typed_data';
import 'package:gpt_tokenizer/gpt_tokenizer.dart';

import 'tokenizer/helper.dart';

import 'ffi/stub.dart'
    if (dart.library.io) 'ffi/io.dart'
    if (dart.library.html) 'ffi/web.dart';

GptTokenizerImpl _loadTokenizerLib() {
  final impl = loadTokenizerImpl(createLibraryImpl());
  return impl;
}

GptTokenizerImpl? _impl;

Future<BPEWrapper> _createTokenizer({
  required String pattern,
  required Map<Uint8List, int> ranks,
  required Map<String, int> specialTokens,
}) async {
  _impl ??= _loadTokenizerLib();

  final encoderEntries = ranks.entries
      .map((e) => EncoderMapEntry(key: e.key, value: e.value))
      .toList();

  final specialEncoderEntries = specialTokens.entries
      .map((e) => SpecialEncoderMapEntry(key: e.key, value: e.value))
      .toList();

  final bpeWrapper = await _impl!.createStaticMethodBpeWrapper(
    encoderEntries: encoderEntries,
    specialTokensEncoderEntries: specialEncoderEntries,
    pattern: pattern,
  );

  return bpeWrapper;
}

class Tokenizer {
  static final _instance = Tokenizer._internal();

  Tokenizer._internal();

  factory Tokenizer() => _instance;

  final _cache = <String, BPEWrapper>{};

  /// encode the given [text] using the tokenizer for the given [modelName]
  /// [text] must be utf8 encode
  Future<List<int>> encode(
    String text, {
    required String modelName,
    List<String> allowedSpecialTokens = const [],
  }) async {
    final tokenizer = await _getTokenizer(modelName);
    return tokenizer.encode(
      text: text,
      allowedSpecialEntries: allowedSpecialTokens,
    );
  }

  /// Encodes a single token. if the [token] is not in the vocabulary, it will
  /// throw exception.
  Future<int> encodeSingleToken(
    String token, {
    required String modelName,
  }) async {
    final bytes = utf8.encode(token);
    final tokenizer = await _getTokenizer(modelName);

    return tokenizer.encodeSingleToken(
      piece: Uint8List.fromList(bytes),
    );
  }

  /// count the length of the encoded text using the given [modelName]
  /// it would not return the encoded text, but only the length of the encoded tokens
  Future<int> count(
    String text, {
    required String modelName,
    List<String> allowedSpecialTokens = const [],
  }) async {
    final tokenizer = await _getTokenizer(modelName);
    return tokenizer.countToken(
      text: text,
      allowedSpecialEntries: allowedSpecialTokens,
    );
  }

  /// decode the given [encoded] tokens using the tokenizer for the given [modelName]
  /// [encoded] should be a list of integers and returned by [encode]
  Future<String> decode(
    Uint32List encoded, {
    required String modelName,
    List<String> allowedSpecialTokens = const [],
  }) async {
    final tokenizer = await _getTokenizer(modelName);

    final decodedBytes = await tokenizer.decodeBytes(
      tokens: encoded,
    );

    return utf8.decode(decodedBytes);
  }

  /// decode a single token using the tokenizer for the given [modelName],
  /// it will throw exception if the [encoded] is not in the vocabulary
  /// [encoded] should be an integer and returned by [encodeSingleToken] or [encode]
  Future<String> decodeSingleToken(int encoded,
      {required String modelName}) async {
    final tokenizer = await _getTokenizer(modelName);

    final decodedBytes = await tokenizer.decodeSingleTokenBytes(
      token: encoded,
    );

    return utf8.decode(decodedBytes);
  }

  /// release the resources used by the tokenizer
  void dispose() {
    if (_cache.isNotEmpty) {
      for (final value in _cache.values) {
        value.bpe.dispose();
      }

      _cache.clear();
    }

    _impl?.dispose();
    _impl = null;
  }

  Future<BPEWrapper> _getTokenizer(String modelName) async {
    final source = getTokenSource(modelName);

    if (_cache.containsKey(source.encodingName)) {
      return _cache[source.encodingName]!;
    } else {
      final map = await loadEncodingFile(source);

      final tokenizer = await _createTokenizer(
        ranks: map,
        pattern: source.pattern,
        specialTokens: source.specialTokens,
      );

      _cache[source.encodingName] = tokenizer;

      return tokenizer;
    }
  }
}
