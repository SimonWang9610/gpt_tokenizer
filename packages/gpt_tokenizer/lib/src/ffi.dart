import 'gen/bridge_generated.dart';

export 'ffi/stub.dart'
    if (dart.library.html) 'ffi/web.dart'
    if (dart.library.io) 'ffi/native.dart';
