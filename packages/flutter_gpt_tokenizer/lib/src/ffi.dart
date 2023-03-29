import 'dart:typed_data';
import 'package:gpt_tokenizer/gpt_tokenizer.dart';
import 'ffi/stub.dart'
    if (dart.library.io) 'ffi/io.dart'
    if (dart.library.html) 'ffi/web.dart';

GptTokenizerImpl loadTokenizerLib() {
  final impl = loadTokenizerImpl(createLibraryImpl());
  return impl;
}

Future<BPEWrapper> createTokenizer({
  required String pattern,
  required Map<Uint8List, int> ranks,
  required Map<String, int> specialTokens,
}) async {
  final impl = loadTokenizerLib();

  final encoderEntries = ranks.entries
      .map((e) => EncoderMapEntry(key: e.key, value: e.value))
      .toList();

  final specialEncoderEntries = specialTokens.entries
      .map((e) => SpecialEncoderMapEntry(key: e.key, value: e.value))
      .toList();

  final bpeWrapper = await impl.createStaticMethodBpeWrapper(
    encoderEntries: encoderEntries,
    specialTokensEncoderEntries: specialEncoderEntries,
    pattern: pattern,
  );

  return bpeWrapper;
}
