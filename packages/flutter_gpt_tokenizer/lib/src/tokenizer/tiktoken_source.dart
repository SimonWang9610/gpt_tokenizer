import 'dart:io';
import 'package:dio/dio.dart';

import 'helper.dart';
import 'constants.dart';

/// [encodingName] is the name of the encoding used by the model, and
/// the mapping could be found in [modelToEncoding]
///
/// [url] is the url to the tiktoken file
/// [pattern] is the Regex pattern used to split the text into tokens
/// [specialTokens] is a map of special tokens that may not be included in the tiktoken file
class TikTokenSource {
  final String encodingName;
  final String url;
  final String pattern;
  final Map<String, int> specialTokens;

  const TikTokenSource({
    required this.encodingName,
    required this.url,
    required this.pattern,
    this.specialTokens = const {},
  });

  /// load the tiktoken file from the cache or download it from the [url]
  /// the default cache directory is determined by [getCachePath]
  /// if the file is not cached, it will be downloaded from the [url]
  /// todo: add support for web
  /// todo: refresh cache if possible
  Future<List<String>> loadTiktokenFile() async {
    final filePath = await getCachePath(url);

    final file = File(filePath);

    if (await file.exists()) {
      return file.readAsLines();
    } else {
      Dio dio = Dio();
      await dio.downloadUri(
        Uri.parse(url),
        filePath,
        data: {
          "Content-Type": "application/octet-stream",
        },
      );
      return file.readAsLines();
    }
  }

  /// ensure the tiktoken file is cached,
  /// if not, download it from the [url]
  /// the returned file path would be used at the rust side
  Future<String> getFilePath() async {
    final filePath = await getCachePath(url);

    final file = File(filePath);

    if (await file.exists()) {
      return filePath;
    } else {
      Dio dio = Dio();
      await dio.downloadUri(
        Uri.parse(url),
        filePath,
        data: {
          "Content-Type": "application/octet-stream",
        },
      );
      return filePath;
    }
  }
}

/// hardcoded TikTokenSource for the models provided by OpenAI, see [modelToEncoding]
const r50kBase = TikTokenSource(
  encodingName: "r50k_base",
  url:
      "https://openaipublic.blob.core.windows.net/encodings/r50k_base.tiktoken",
  pattern:
      r"'s|'t|'re|'ve|'m|'ll|'d| ?\p{L}+| ?\p{N}+| ?[^\s\p{L}\p{N}]+|\s+(?!\S)|\s+",
  specialTokens: {endOfText: 50256},
);

/// hardcoded TikTokenSource for the models provided by OpenAI, see [modelToEncoding]
const p50kBase = TikTokenSource(
  encodingName: "p50k_base",
  url:
      "https://openaipublic.blob.core.windows.net/encodings/p50k_base.tiktoken",
  pattern:
      r"'s|'t|'re|'ve|'m|'ll|'d| ?\p{L}+| ?\p{N}+| ?[^\s\p{L}\p{N}]+|\s+(?!\S)|\s+",
  specialTokens: {endOfText: 50256},
);

/// hardcoded TikTokenSource for the models provided by OpenAI, see [modelToEncoding]
const p50kEdit = TikTokenSource(
  encodingName: "p50k_edit",
  url:
      "https://openaipublic.blob.core.windows.net/encodings/p50k_base.tiktoken",
  pattern:
      r"'s|'t|'re|'ve|'m|'ll|'d| ?\p{L}+| ?\p{N}+| ?[^\s\p{L}\p{N}]+|\s+(?!\S)|\s+",
  specialTokens: {
    endOfText: 50256,
    fimPrefix: 50281,
    fimMiddle: 50282,
    fimSuffix: 50283
  },
);

/// hardcoded TikTokenSource for the models provided by OpenAI, see [modelToEncoding]
const cl100kBase = TikTokenSource(
  encodingName: "cl100k_base",
  url:
      "https://openaipublic.blob.core.windows.net/encodings/cl100k_base.tiktoken",
  pattern:
      r"(?i:'s|'t|'re|'ve|'m|'ll|'d)|[^\r\n\p{L}\p{N}]?\p{L}+|\p{N}{1,3}| ?[^\s\p{L}\p{N}]+[\r\n]*|\s*[\r\n]+|\s+(?!\S)|\s+",
  specialTokens: {
    endOfText: 100257,
    fimPrefix: 100258,
    fimMiddle: 100259,
    fimSuffix: 100260,
    endOfPrompt: 100276,
  },
);
