import 'dart:convert';
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

  BPEWrapper? tokenizer;

  @override
  void initState() {
    super.initState();
    _initTokenizer();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initTokenizer() async {
    tokenizer = await Tokenizer.getTokenizer("gpt-4");
  }

  Uint32List? _encoded;
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Text',
                    hintText: "Enter your prompt here",
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
          onPressed: () async {
            if (tokenizer == null) return;

            final text = _controller.text;
            final encoded = await tokenizer!.encode(
              text: text,
              allowedSpecialEntries: const [],
            );

            final decoded = await tokenizer!.decodeBytes(tokens: encoded);

            final count = await tokenizer!.countToken(
              text: text,
              allowedSpecialEntries: const [],
            );

            setState(() {
              _encoded = encoded;
              _decoded = utf8.decode(decoded);
              _count = count;
            });
          },
          child: const Text('Encode'),
        ),
      ),
    );
  }
}
