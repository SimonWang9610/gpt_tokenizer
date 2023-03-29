import 'dart:ffi';

import 'package:gpt_tokenizer/src/gen/bridge_generated.dart';

typedef ExternalLibrary = DynamicLibrary;

TokenizerImpl loadTokenizerImpl(ExternalLibrary library) {
  return TokenizerImpl(library);
}
