import 'dart:ffi';

import 'package:gpt_tokenizer/src/gen/bridge_generated.dart';

typedef ExternalLibrary = DynamicLibrary;

GptTokenizerImpl loadTokenizerImpl(ExternalLibrary library) {
  return GptTokenizerImpl(library);
}
