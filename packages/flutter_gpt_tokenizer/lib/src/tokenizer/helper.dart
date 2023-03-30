import 'dart:convert';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';

import 'constants.dart';
import 'tiktoken_source.dart';

/// get the mapping of model name to encoding name from [modelToEncoding]
String getEncodingName(String modelName) {
  if (modelName.startsWith("gpt-4-")) {
    return "cl100k_base";
  } else if (modelName.startsWith("gpt-3.5-turbo-")) {
    return "cl100k_base";
  } else if (modelToEncoding.containsKey(modelName)) {
    return modelToEncoding[modelName]!;
  } else {
    throw Exception("Unknown model name: $modelName");
  }
}

Future<String?> _getAppDirectory() async {
  return getApplicationDocumentsDirectory().then((value) => value.path);
}

String _hashFileUrl(String url) {
  final bytes = utf8.encode(url);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

/// get the cache directory for the given url
Future<String> getCachePath(String url) async {
  final appDir = await _getAppDirectory();

  if (appDir == null) {
    throw Exception(
        "Could not get app directory. possibly not supported for the current platform.");
  }

  final hash = _hashFileUrl(url);
  return "$appDir/$cachePath/$hash.tiktoken";
}

/// get the [TikTokenSource] for the given model name
TikTokenSource getTokenSource(String modelName) {
  final encoding = getEncodingName(modelName);

  switch (encoding) {
    case "r50k_base":
      return r50kBase;
    case "p50k_base":
      return p50kBase;
    case "p50k_edit":
      return p50kEdit;
    case "cl100k_base":
      return cl100kBase;
    default:
      throw Exception("Unknown encoding: $encoding");
  }
}

/// load the tiktoken file from the [source] and return a map of token to rank
Future<Map<Uint8List, int>> loadEncodingFile(TikTokenSource source) async {
  final lines = await source.loadTiktokenFile();

  final map = <Uint8List, int>{};
  for (final line in lines) {
    final split = line.split(" ");
    final token = base64.decode(split[0]);
    final rank = int.parse(split[1]);

    map[token] = rank;
  }

  return map;
}
