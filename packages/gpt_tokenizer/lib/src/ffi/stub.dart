import 'package:gpt_tokenizer/src/gen/bridge_generated.dart';

typedef ExternalLibrary = Object;

GptTokenizerImpl loadTokenizerImpl(ExternalLibrary library) {
  throw UnsupportedError('Cannot load tokenizer on this platform');
}
