import 'dart:typed_data';
import 'package:flutter_gpt_tokenizer/flutter_gpt_tokenizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  const modelName = "gpt-4";
  const text = "hello world";

  TestWidgetsFlutterBinding.ensureInitialized();

  test("test encode correctly", () async {
    final encoded = await Tokenizer().encode(
      text,
      modelName: modelName,
    );

    final decoded = await Tokenizer()
        .decode(Uint32List.fromList(encoded), modelName: modelName);

    final count = await Tokenizer().count(
      text,
      modelName: modelName,
    );

    expect(decoded, text);
    expect(encoded.length, count);
    expect(count, 2);
  });
}
