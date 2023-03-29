import 'package:gpt_tokenizer/src/gen/bridge_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

typedef ExternalLibrary = WasmModule;

GptTokenizerImpl loadTokenizerImpl(ExternalLibrary library) {
  return GptTokenizerImpl.wasm(library);
}
