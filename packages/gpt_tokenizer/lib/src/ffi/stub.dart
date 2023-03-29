import 'package:gpt_tokenizer/src/gen/bridge_generated.dart';

typedef ExternalLibrary = Object;

TokenizerImpl loadTokenizerImpl(ExternalLibrary library) {
  throw UnsupportedError('Cannot load tokenizer on this platform');
}
