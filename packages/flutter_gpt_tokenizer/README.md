# flutter_gpt_tokenizer

A package helps you encode/count/decode the tokens based on your ChatGPT prompt, so that you could know how many tokens your request would consume before sending requests to OpenAI.

This package is not the official implementation from OpenAI but use the same tiktoken files and BPE algorithm from [OpenAI tiktoken(python)](https://github.com/openai/tiktoken)

## Features

1. `encode` your prompt and return the encoded bytes
2. `count` the tokens of your prompt but no return the encoded bytes
3. `decode` the encoded tokens from your prompt.

## Usage

> if you only want to know the length of the tokens of your prompt, better use `Tokenizer().count`

- encode your prompt

```dart
final encoded = await Tokenizer().encode(<your prompt>, modelName: "gpt-3.5-turbo");
```

- count the tokens of your prompt

```dart
final count = await Tokenizer().count(
  <your prompt>,
  modelName: "gpt-3.5-turbo,
);
```

The tokenizer for different `modelName` would be cached, so it would only initialize once for a different `modelName`. Therefore, remembering to dispose `Tokenizer` once you do not need using them:

```dart
Tokenizer().dispose()
```

## Design

This package utilizes [flutter_rust_bridge](https://pub.dev/packages/flutter_rust_bridge) to bridge the BPE algorithm of OpenAI to your flutter application.

### Load and cache `tiktoken` file

When you first use `Tokenizer()`, it would try to load and cache the tiktoken file for the specific `modelName` from the public endpoints of OpenAI

### Initialize the instance `BPEWrapper` for a specific `modelName`

If the `BPEWrapper` for a specific `modelName` is not found in `Tokenizer()`, it would notify the rust side to read its tiktoken file and then construct an instance of `BPEWrapper` for the specific `modelName`, so that the flutter/dart side could use the ability to `encode/decode/count` for your ChatGPT prompt.

## Supported models:

> `gpt-4-*` and `gpt-3.5-turbo-*` are also supported

```json
  "gpt-4": "cl100k_base",
  "gpt-3.5-turbo": "cl100k_base",
  "text-davinci-003": "p50k_base",
  "text-davinci-002": "p50k_base",
  "text-davinci-001": "r50k_base",
  "text-curie-001": "r50k_base",
  "text-babbage-001": "r50k_base",
  "text-ada-001": "r50k_base",
  "davinci": "r50k_base",
  "curie": "r50k_base",
  "babbage": "r50k_base",
  "ada": "r50k_base",
  "code-davinci-002": "p50k_base",
  "code-davinci-001": "p50k_base",
  "code-cushman-002": "p50k_base",
  "code-cushman-001": "p50k_base",
  "davinci-codex": "p50k_base",
  "cushman-codex": "p50k_base",
  "text-davinci-edit-001": "p50k_edit",
  "code-davinci-edit-001": "p50k_edit",
  "text-embedding-ada-002": "cl100k_base",
  "text-similarity-davinci-001": "r50k_base",
  "text-similarity-curie-001": "r50k_base",
  "text-similarity-babbage-001": "r50k_base",
  "text-similarity-ada-001": "r50k_base",
  "text-search-davinci-doc-001": "r50k_base",
  "text-search-curie-doc-001": "r50k_base",
  "text-search-babbage-doc-001": "r50k_base",
  "text-search-ada-doc-001": "r50k_base",
  "code-search-babbage-code-001": "r50k_base",
  "code-search-ada-code-001": "r50k_base",
```
