import 'package:gpt_tokenizer/src/gen/bridge_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

typedef ExternalLibrary = WasmModule;

TokenizerImpl loadTokenizerImpl(ExternalLibrary library) {
  return TokenizerImpl.wasm(library);
}
