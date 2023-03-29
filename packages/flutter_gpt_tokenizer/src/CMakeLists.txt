# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(flutter_gpt_tokenizer_library VERSION 0.0.1 LANGUAGES C)

add_library(flutter_gpt_tokenizer SHARED
  "flutter_gpt_tokenizer.c"
)

set_target_properties(flutter_gpt_tokenizer PROPERTIES
  PUBLIC_HEADER flutter_gpt_tokenizer.h
  OUTPUT_NAME "flutter_gpt_tokenizer"
)

target_compile_definitions(flutter_gpt_tokenizer PUBLIC DART_SHARED_LIB)
