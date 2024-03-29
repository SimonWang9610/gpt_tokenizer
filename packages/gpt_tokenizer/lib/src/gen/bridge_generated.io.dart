// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.82.6.
// ignore_for_file: non_constant_identifier_names, unused_element, duplicate_ignore, directives_ordering, curly_braces_in_flow_control_structures, unnecessary_lambdas, slash_for_doc_comments, prefer_const_literals_to_create_immutables, implicit_dynamic_list_literal, duplicate_import, unused_import, unnecessary_import, prefer_single_quotes, prefer_const_constructors, use_super_parameters, always_use_package_imports, annotate_overrides, invalid_use_of_protected_member, constant_identifier_names, invalid_use_of_internal_member, prefer_is_empty, unnecessary_const

import 'dart:convert';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:uuid/uuid.dart';
import 'bridge_generated.dart';
export 'bridge_generated.dart';
import 'dart:ffi' as ffi;

class GptTokenizerPlatform extends FlutterRustBridgeBase<GptTokenizerWire> {
  GptTokenizerPlatform(ffi.DynamicLibrary dylib) : super(GptTokenizerWire(dylib));

// Section: api2wire

  @protected
  wire_CoreBpe api2wire_CoreBpe(CoreBpe raw) {
    final ptr = inner.new_CoreBpe();
    _api_fill_to_wire_CoreBpe(raw, ptr);
    return ptr;
  }

  @protected
  ffi.Pointer<wire_uint_8_list> api2wire_String(String raw) {
    return api2wire_uint_8_list(utf8.encoder.convert(raw));
  }

  @protected
  ffi.Pointer<wire_StringList> api2wire_StringList(List<String> raw) {
    final ans = inner.new_StringList_0(raw.length);
    for (var i = 0; i < raw.length; i++) {
      ans.ref.ptr[i] = api2wire_String(raw[i]);
    }
    return ans;
  }

  @protected
  ffi.Pointer<wire_BPEWrapper> api2wire_box_autoadd_bpe_wrapper(BPEWrapper raw) {
    final ptr = inner.new_box_autoadd_bpe_wrapper_0();
    _api_fill_to_wire_bpe_wrapper(raw, ptr.ref);
    return ptr;
  }

  @protected
  ffi.Pointer<wire_list_encoder_map_entry> api2wire_list_encoder_map_entry(List<EncoderMapEntry> raw) {
    final ans = inner.new_list_encoder_map_entry_0(raw.length);
    for (var i = 0; i < raw.length; ++i) {
      _api_fill_to_wire_encoder_map_entry(raw[i], ans.ref.ptr[i]);
    }
    return ans;
  }

  @protected
  ffi.Pointer<wire_list_special_encoder_map_entry> api2wire_list_special_encoder_map_entry(List<SpecialEncoderMapEntry> raw) {
    final ans = inner.new_list_special_encoder_map_entry_0(raw.length);
    for (var i = 0; i < raw.length; ++i) {
      _api_fill_to_wire_special_encoder_map_entry(raw[i], ans.ref.ptr[i]);
    }
    return ans;
  }

  @protected
  ffi.Pointer<wire_uint_32_list> api2wire_uint_32_list(Uint32List raw) {
    final ans = inner.new_uint_32_list_0(raw.length);
    ans.ref.ptr.asTypedList(raw.length).setAll(0, raw);
    return ans;
  }

  @protected
  ffi.Pointer<wire_uint_8_list> api2wire_uint_8_list(Uint8List raw) {
    final ans = inner.new_uint_8_list_0(raw.length);
    ans.ref.ptr.asTypedList(raw.length).setAll(0, raw);
    return ans;
  }

// Section: finalizer

  late final OpaqueTypeFinalizer _CoreBpeFinalizer = OpaqueTypeFinalizer(inner._drop_opaque_CoreBpePtr);
  OpaqueTypeFinalizer get CoreBpeFinalizer => _CoreBpeFinalizer;
// Section: api_fill_to_wire

  void _api_fill_to_wire_CoreBpe(CoreBpe apiObj, wire_CoreBpe wireObj) {
    wireObj.ptr = apiObj.shareOrMove();
  }

  void _api_fill_to_wire_box_autoadd_bpe_wrapper(BPEWrapper apiObj, ffi.Pointer<wire_BPEWrapper> wireObj) {
    _api_fill_to_wire_bpe_wrapper(apiObj, wireObj.ref);
  }

  void _api_fill_to_wire_bpe_wrapper(BPEWrapper apiObj, wire_BPEWrapper wireObj) {
    wireObj.bpe = api2wire_CoreBpe(apiObj.bpe);
  }

  void _api_fill_to_wire_encoder_map_entry(EncoderMapEntry apiObj, wire_EncoderMapEntry wireObj) {
    wireObj.key = api2wire_uint_8_list(apiObj.key);
    wireObj.value = api2wire_usize(apiObj.value);
  }

  void _api_fill_to_wire_special_encoder_map_entry(SpecialEncoderMapEntry apiObj, wire_SpecialEncoderMapEntry wireObj) {
    wireObj.key = api2wire_String(apiObj.key);
    wireObj.value = api2wire_usize(apiObj.value);
  }
}

// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_positional_boolean_parameters, annotate_overrides, constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint

/// generated by flutter_rust_bridge
class GptTokenizerWire implements FlutterRustBridgeWireBase {
  @internal
  late final dartApi = DartApiDl(init_frb_dart_api_dl);

  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName) _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  GptTokenizerWire(ffi.DynamicLibrary dynamicLibrary) : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  GptTokenizerWire.fromLookup(ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName) lookup) : _lookup = lookup;

  void store_dart_post_cobject(
    DartPostCObjectFnType ptr,
  ) {
    return _store_dart_post_cobject(
      ptr,
    );
  }

  late final _store_dart_post_cobjectPtr = _lookup<ffi.NativeFunction<ffi.Void Function(DartPostCObjectFnType)>>('store_dart_post_cobject');
  late final _store_dart_post_cobject = _store_dart_post_cobjectPtr.asFunction<void Function(DartPostCObjectFnType)>();

  Object get_dart_object(
    int ptr,
  ) {
    return _get_dart_object(
      ptr,
    );
  }

  late final _get_dart_objectPtr = _lookup<ffi.NativeFunction<ffi.Handle Function(ffi.UintPtr)>>('get_dart_object');
  late final _get_dart_object = _get_dart_objectPtr.asFunction<Object Function(int)>();

  void drop_dart_object(
    int ptr,
  ) {
    return _drop_dart_object(
      ptr,
    );
  }

  late final _drop_dart_objectPtr = _lookup<ffi.NativeFunction<ffi.Void Function(ffi.UintPtr)>>('drop_dart_object');
  late final _drop_dart_object = _drop_dart_objectPtr.asFunction<void Function(int)>();

  int new_dart_opaque(
    Object handle,
  ) {
    return _new_dart_opaque(
      handle,
    );
  }

  late final _new_dart_opaquePtr = _lookup<ffi.NativeFunction<ffi.UintPtr Function(ffi.Handle)>>('new_dart_opaque');
  late final _new_dart_opaque = _new_dart_opaquePtr.asFunction<int Function(Object)>();

  int init_frb_dart_api_dl(
    ffi.Pointer<ffi.Void> obj,
  ) {
    return _init_frb_dart_api_dl(
      obj,
    );
  }

  late final _init_frb_dart_api_dlPtr = _lookup<ffi.NativeFunction<ffi.IntPtr Function(ffi.Pointer<ffi.Void>)>>('init_frb_dart_api_dl');
  late final _init_frb_dart_api_dl = _init_frb_dart_api_dlPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  void wire_create__static_method__BPEWrapper(
    int port_,
    ffi.Pointer<wire_list_encoder_map_entry> encoder_entries,
    ffi.Pointer<wire_list_special_encoder_map_entry> special_tokens_encoder_entries,
    ffi.Pointer<wire_uint_8_list> pattern,
  ) {
    return _wire_create__static_method__BPEWrapper(
      port_,
      encoder_entries,
      special_tokens_encoder_entries,
      pattern,
    );
  }

  late final _wire_create__static_method__BPEWrapperPtr = _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64, ffi.Pointer<wire_list_encoder_map_entry>, ffi.Pointer<wire_list_special_encoder_map_entry>, ffi.Pointer<wire_uint_8_list>)>>('wire_create__static_method__BPEWrapper');
  late final _wire_create__static_method__BPEWrapper = _wire_create__static_method__BPEWrapperPtr.asFunction<void Function(int, ffi.Pointer<wire_list_encoder_map_entry>, ffi.Pointer<wire_list_special_encoder_map_entry>, ffi.Pointer<wire_uint_8_list>)>();

  void wire_load__static_method__BPEWrapper(
    int port_,
    ffi.Pointer<wire_uint_8_list> path,
    ffi.Pointer<wire_list_special_encoder_map_entry> special_tokens_encoder_entries,
    ffi.Pointer<wire_uint_8_list> pattern,
  ) {
    return _wire_load__static_method__BPEWrapper(
      port_,
      path,
      special_tokens_encoder_entries,
      pattern,
    );
  }

  late final _wire_load__static_method__BPEWrapperPtr = _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64, ffi.Pointer<wire_uint_8_list>, ffi.Pointer<wire_list_special_encoder_map_entry>, ffi.Pointer<wire_uint_8_list>)>>('wire_load__static_method__BPEWrapper');
  late final _wire_load__static_method__BPEWrapper = _wire_load__static_method__BPEWrapperPtr.asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>, ffi.Pointer<wire_list_special_encoder_map_entry>, ffi.Pointer<wire_uint_8_list>)>();

  void wire_encode_ordinary__method__BPEWrapper(
    int port_,
    ffi.Pointer<wire_BPEWrapper> that,
    ffi.Pointer<wire_uint_8_list> text,
  ) {
    return _wire_encode_ordinary__method__BPEWrapper(
      port_,
      that,
      text,
    );
  }

  late final _wire_encode_ordinary__method__BPEWrapperPtr = _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64, ffi.Pointer<wire_BPEWrapper>, ffi.Pointer<wire_uint_8_list>)>>('wire_encode_ordinary__method__BPEWrapper');
  late final _wire_encode_ordinary__method__BPEWrapper = _wire_encode_ordinary__method__BPEWrapperPtr.asFunction<void Function(int, ffi.Pointer<wire_BPEWrapper>, ffi.Pointer<wire_uint_8_list>)>();

  void wire_encode__method__BPEWrapper(
    int port_,
    ffi.Pointer<wire_BPEWrapper> that,
    ffi.Pointer<wire_uint_8_list> text,
    ffi.Pointer<wire_StringList> allowed_special_entries,
  ) {
    return _wire_encode__method__BPEWrapper(
      port_,
      that,
      text,
      allowed_special_entries,
    );
  }

  late final _wire_encode__method__BPEWrapperPtr = _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64, ffi.Pointer<wire_BPEWrapper>, ffi.Pointer<wire_uint_8_list>, ffi.Pointer<wire_StringList>)>>('wire_encode__method__BPEWrapper');
  late final _wire_encode__method__BPEWrapper = _wire_encode__method__BPEWrapperPtr.asFunction<void Function(int, ffi.Pointer<wire_BPEWrapper>, ffi.Pointer<wire_uint_8_list>, ffi.Pointer<wire_StringList>)>();

  void wire_count_token__method__BPEWrapper(
    int port_,
    ffi.Pointer<wire_BPEWrapper> that,
    ffi.Pointer<wire_uint_8_list> text,
    ffi.Pointer<wire_StringList> allowed_special_entries,
  ) {
    return _wire_count_token__method__BPEWrapper(
      port_,
      that,
      text,
      allowed_special_entries,
    );
  }

  late final _wire_count_token__method__BPEWrapperPtr = _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64, ffi.Pointer<wire_BPEWrapper>, ffi.Pointer<wire_uint_8_list>, ffi.Pointer<wire_StringList>)>>('wire_count_token__method__BPEWrapper');
  late final _wire_count_token__method__BPEWrapper = _wire_count_token__method__BPEWrapperPtr.asFunction<void Function(int, ffi.Pointer<wire_BPEWrapper>, ffi.Pointer<wire_uint_8_list>, ffi.Pointer<wire_StringList>)>();

  void wire_encode_bytes__method__BPEWrapper(
    int port_,
    ffi.Pointer<wire_BPEWrapper> that,
    ffi.Pointer<wire_uint_8_list> bytes,
  ) {
    return _wire_encode_bytes__method__BPEWrapper(
      port_,
      that,
      bytes,
    );
  }

  late final _wire_encode_bytes__method__BPEWrapperPtr = _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64, ffi.Pointer<wire_BPEWrapper>, ffi.Pointer<wire_uint_8_list>)>>('wire_encode_bytes__method__BPEWrapper');
  late final _wire_encode_bytes__method__BPEWrapper = _wire_encode_bytes__method__BPEWrapperPtr.asFunction<void Function(int, ffi.Pointer<wire_BPEWrapper>, ffi.Pointer<wire_uint_8_list>)>();

  void wire_encode_single_token__method__BPEWrapper(
    int port_,
    ffi.Pointer<wire_BPEWrapper> that,
    ffi.Pointer<wire_uint_8_list> piece,
  ) {
    return _wire_encode_single_token__method__BPEWrapper(
      port_,
      that,
      piece,
    );
  }

  late final _wire_encode_single_token__method__BPEWrapperPtr = _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64, ffi.Pointer<wire_BPEWrapper>, ffi.Pointer<wire_uint_8_list>)>>('wire_encode_single_token__method__BPEWrapper');
  late final _wire_encode_single_token__method__BPEWrapper = _wire_encode_single_token__method__BPEWrapperPtr.asFunction<void Function(int, ffi.Pointer<wire_BPEWrapper>, ffi.Pointer<wire_uint_8_list>)>();

  void wire_decode_bytes__method__BPEWrapper(
    int port_,
    ffi.Pointer<wire_BPEWrapper> that,
    ffi.Pointer<wire_uint_32_list> tokens,
  ) {
    return _wire_decode_bytes__method__BPEWrapper(
      port_,
      that,
      tokens,
    );
  }

  late final _wire_decode_bytes__method__BPEWrapperPtr = _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64, ffi.Pointer<wire_BPEWrapper>, ffi.Pointer<wire_uint_32_list>)>>('wire_decode_bytes__method__BPEWrapper');
  late final _wire_decode_bytes__method__BPEWrapper = _wire_decode_bytes__method__BPEWrapperPtr.asFunction<void Function(int, ffi.Pointer<wire_BPEWrapper>, ffi.Pointer<wire_uint_32_list>)>();

  void wire_decode_single_token_bytes__method__BPEWrapper(
    int port_,
    ffi.Pointer<wire_BPEWrapper> that,
    int token,
  ) {
    return _wire_decode_single_token_bytes__method__BPEWrapper(
      port_,
      that,
      token,
    );
  }

  late final _wire_decode_single_token_bytes__method__BPEWrapperPtr = _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64, ffi.Pointer<wire_BPEWrapper>, ffi.UintPtr)>>('wire_decode_single_token_bytes__method__BPEWrapper');
  late final _wire_decode_single_token_bytes__method__BPEWrapper = _wire_decode_single_token_bytes__method__BPEWrapperPtr.asFunction<void Function(int, ffi.Pointer<wire_BPEWrapper>, int)>();

  wire_CoreBpe new_CoreBpe() {
    return _new_CoreBpe();
  }

  late final _new_CoreBpePtr = _lookup<ffi.NativeFunction<wire_CoreBpe Function()>>('new_CoreBpe');
  late final _new_CoreBpe = _new_CoreBpePtr.asFunction<wire_CoreBpe Function()>();

  ffi.Pointer<wire_StringList> new_StringList_0(
    int len,
  ) {
    return _new_StringList_0(
      len,
    );
  }

  late final _new_StringList_0Ptr = _lookup<ffi.NativeFunction<ffi.Pointer<wire_StringList> Function(ffi.Int32)>>('new_StringList_0');
  late final _new_StringList_0 = _new_StringList_0Ptr.asFunction<ffi.Pointer<wire_StringList> Function(int)>();

  ffi.Pointer<wire_BPEWrapper> new_box_autoadd_bpe_wrapper_0() {
    return _new_box_autoadd_bpe_wrapper_0();
  }

  late final _new_box_autoadd_bpe_wrapper_0Ptr = _lookup<ffi.NativeFunction<ffi.Pointer<wire_BPEWrapper> Function()>>('new_box_autoadd_bpe_wrapper_0');
  late final _new_box_autoadd_bpe_wrapper_0 = _new_box_autoadd_bpe_wrapper_0Ptr.asFunction<ffi.Pointer<wire_BPEWrapper> Function()>();

  ffi.Pointer<wire_list_encoder_map_entry> new_list_encoder_map_entry_0(
    int len,
  ) {
    return _new_list_encoder_map_entry_0(
      len,
    );
  }

  late final _new_list_encoder_map_entry_0Ptr = _lookup<ffi.NativeFunction<ffi.Pointer<wire_list_encoder_map_entry> Function(ffi.Int32)>>('new_list_encoder_map_entry_0');
  late final _new_list_encoder_map_entry_0 = _new_list_encoder_map_entry_0Ptr.asFunction<ffi.Pointer<wire_list_encoder_map_entry> Function(int)>();

  ffi.Pointer<wire_list_special_encoder_map_entry> new_list_special_encoder_map_entry_0(
    int len,
  ) {
    return _new_list_special_encoder_map_entry_0(
      len,
    );
  }

  late final _new_list_special_encoder_map_entry_0Ptr = _lookup<ffi.NativeFunction<ffi.Pointer<wire_list_special_encoder_map_entry> Function(ffi.Int32)>>('new_list_special_encoder_map_entry_0');
  late final _new_list_special_encoder_map_entry_0 = _new_list_special_encoder_map_entry_0Ptr.asFunction<ffi.Pointer<wire_list_special_encoder_map_entry> Function(int)>();

  ffi.Pointer<wire_uint_32_list> new_uint_32_list_0(
    int len,
  ) {
    return _new_uint_32_list_0(
      len,
    );
  }

  late final _new_uint_32_list_0Ptr = _lookup<ffi.NativeFunction<ffi.Pointer<wire_uint_32_list> Function(ffi.Int32)>>('new_uint_32_list_0');
  late final _new_uint_32_list_0 = _new_uint_32_list_0Ptr.asFunction<ffi.Pointer<wire_uint_32_list> Function(int)>();

  ffi.Pointer<wire_uint_8_list> new_uint_8_list_0(
    int len,
  ) {
    return _new_uint_8_list_0(
      len,
    );
  }

  late final _new_uint_8_list_0Ptr = _lookup<ffi.NativeFunction<ffi.Pointer<wire_uint_8_list> Function(ffi.Int32)>>('new_uint_8_list_0');
  late final _new_uint_8_list_0 = _new_uint_8_list_0Ptr.asFunction<ffi.Pointer<wire_uint_8_list> Function(int)>();

  void drop_opaque_CoreBpe(
    ffi.Pointer<ffi.Void> ptr,
  ) {
    return _drop_opaque_CoreBpe(
      ptr,
    );
  }

  late final _drop_opaque_CoreBpePtr = _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('drop_opaque_CoreBpe');
  late final _drop_opaque_CoreBpe = _drop_opaque_CoreBpePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  ffi.Pointer<ffi.Void> share_opaque_CoreBpe(
    ffi.Pointer<ffi.Void> ptr,
  ) {
    return _share_opaque_CoreBpe(
      ptr,
    );
  }

  late final _share_opaque_CoreBpePtr = _lookup<ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('share_opaque_CoreBpe');
  late final _share_opaque_CoreBpe = _share_opaque_CoreBpePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  void free_WireSyncReturn(
    WireSyncReturn ptr,
  ) {
    return _free_WireSyncReturn(
      ptr,
    );
  }

  late final _free_WireSyncReturnPtr = _lookup<ffi.NativeFunction<ffi.Void Function(WireSyncReturn)>>('free_WireSyncReturn');
  late final _free_WireSyncReturn = _free_WireSyncReturnPtr.asFunction<void Function(WireSyncReturn)>();
}

final class _Dart_Handle extends ffi.Opaque {}

final class wire_uint_8_list extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> ptr;

  @ffi.Int32()
  external int len;
}

final class wire_EncoderMapEntry extends ffi.Struct {
  external ffi.Pointer<wire_uint_8_list> key;

  @ffi.UintPtr()
  external int value;
}

final class wire_list_encoder_map_entry extends ffi.Struct {
  external ffi.Pointer<wire_EncoderMapEntry> ptr;

  @ffi.Int32()
  external int len;
}

final class wire_SpecialEncoderMapEntry extends ffi.Struct {
  external ffi.Pointer<wire_uint_8_list> key;

  @ffi.UintPtr()
  external int value;
}

final class wire_list_special_encoder_map_entry extends ffi.Struct {
  external ffi.Pointer<wire_SpecialEncoderMapEntry> ptr;

  @ffi.Int32()
  external int len;
}

final class wire_CoreBpe extends ffi.Struct {
  external ffi.Pointer<ffi.Void> ptr;
}

final class wire_BPEWrapper extends ffi.Struct {
  external wire_CoreBpe bpe;
}

final class wire_StringList extends ffi.Struct {
  external ffi.Pointer<ffi.Pointer<wire_uint_8_list>> ptr;

  @ffi.Int32()
  external int len;
}

final class wire_uint_32_list extends ffi.Struct {
  external ffi.Pointer<ffi.Uint32> ptr;

  @ffi.Int32()
  external int len;
}

typedef DartPostCObjectFnType = ffi.Pointer<ffi.NativeFunction<ffi.Bool Function(DartPort port_id, ffi.Pointer<ffi.Void> message)>>;
typedef DartPort = ffi.Int64;
