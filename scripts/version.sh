#!/bin/bash

VERSION_NUM=`awk '/^version: /{print $2}' packages/gpt_tokenizer/pubspec.yaml`
CURR_VERSION=gpt_tokenizer-v`awk '/^version: /{print $2}' packages/gpt_tokenizer/pubspec.yaml`

# iOS & macOS
APPLE_HEADER="release_tag_name = '$CURR_VERSION' # generated; do not edit"
sed -i.bak "1 s/.*/$APPLE_HEADER/" packages/flutter_gpt_tokenizer/ios/flutter_gpt_tokenizer.podspec
sed -i.bak "1 s/.*/$APPLE_HEADER/" packages/flutter_gpt_tokenizer/macos/flutter_gpt_tokenizer.podspec

# set pod spec.version
APPLE_POD_VERSION="release_pod_version = '$VERSION_NUM' # generated; do not edit"
sed -i.bak "2 s/.*/$APPLE_POD_VERSION/" packages/flutter_gpt_tokenizer/ios/flutter_gpt_tokenizer.podspec
sed -i.bak "2 s/.*/$APPLE_POD_VERSION/" packages/flutter_gpt_tokenizer/macos/flutter_gpt_tokenizer.podspec

rm packages/flutter_gpt_tokenizer/macos/*.bak packages/flutter_gpt_tokenizer/ios/*.bak

# CMake platforms (Linux, Windows, and Android)
CMAKE_HEADER="set(LibraryVersion \"$CURR_VERSION\") # generated; do not edit"
for CMAKE_PLATFORM in android linux windows
do
    sed -i.bak "1 s/.*/$CMAKE_HEADER/" packages/flutter_gpt_tokenizer/$CMAKE_PLATFORM/CMakeLists.txt
    rm packages/flutter_gpt_tokenizer/$CMAKE_PLATFORM/*.bak
done

# debug bash script
APPLE_DEBUG_ZIP="DEBUGZIP=\"$CURR_VERSION.zip\" # generated; do not edit"
sed -i.bak "2 s/.*/$APPLE_DEBUG_ZIP/" scripts/build-apple.sh

ANDROID_DEBUG_ZIP="DEBUGZIP=\"$CURR_VERSION.tar.gz\" # generated; do not edit"
sed -i.bak "2 s/.*/$ANDROID_DEBUG_ZIP/" scripts/build-android.sh

rm scripts/*.bak

git add packages/flutter_gpt_tokenizer/