import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_gpt_tokenizer/flutter_gpt_tokenizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    Tokenizer().dispose();
    super.dispose();
  }

  List<int>? _encoded;
  String? _decoded;
  int? _count;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Packages'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Text',
                    hintText: "Enter your prompt here",
                    suffixIcon: _buildModelSelector(),
                  ),
                ),
                const SizedBox(height: 10),
                if (_encoded != null)
                  Text(
                    'Encoded: ${_encoded!.toList()}',
                    style: const TextStyle(fontSize: 20),
                  ),
                if (_decoded != null)
                  Text(
                    'Decoded: $_decoded',
                    style: const TextStyle(fontSize: 20),
                  ),
                if (_count != null)
                  Text(
                    'Count: $_count',
                    style: const TextStyle(fontSize: 20),
                  ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _encode,
          child: const Text(
            'Encode',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }

  void _encodeSingleToken() async {
    final encoded = await Tokenizer().encodeSingleToken(
      _controller.text,
      modelName: _currentModel,
    );

    _controller.clear();

    final decoded =
        await Tokenizer().decodeSingleToken(encoded, modelName: _currentModel);

    setState(() {
      _encoded = [encoded];
      _decoded = decoded;
      _count = 1;
    });
  }

  void _encode() async {
    final text = _controller.text;
    Tokenizer()
        .encode(
      text,
      modelName: _currentModel,
    )
        .then((encoded) async {
      print("Encoded: $encoded");
      final decoded = await Tokenizer()
          .decode(Uint32List.fromList(encoded), modelName: _currentModel);

      final count = await Tokenizer().count(
        text,
        modelName: _currentModel,
      );

      setState(() {
        _encoded = encoded;
        _decoded = decoded;
        _count = count;
      });
    });

    Tokenizer().encode("$text, copy", modelName: _currentModel).then((encoded) {
      print("Encoded copy: $encoded");
    });
  }

  String _currentModel = "gpt-4";

  Widget _buildModelSelector() {
    return DropdownButton<String>(
      value: _currentModel,
      items: const [
        DropdownMenuItem(
          value: "gpt-4",
          child: Text("gpt-4"),
        ),
        DropdownMenuItem(
          value: "gpt-3.5-turbo",
          child: Text("gpt-3.5-turbo"),
        ),
        DropdownMenuItem(
          value: "text-davinci-003",
          child: Text("text-davinci-003"),
        ),
        DropdownMenuItem(
          value: "text-davinci-edit-001",
          child: Text("text-davinci-edit-001"),
        ),
        DropdownMenuItem(
          value: "davinci",
          child: Text("davinci"),
        ),
      ],
      onChanged: (value) async {
        if (value == null) return;

        print("set tokenizer for: $value");
        setState(() {
          _currentModel = value;
        });
      },
    );
  }
}
