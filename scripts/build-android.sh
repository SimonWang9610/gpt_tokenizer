#!/bin/bash
DEBUGZIP="gpt_tokenizer-v0.0.1.tar.gz" # generated; do not edit
# Setup
BUILD_DIR=platform-build
mkdir $BUILD_DIR
cd $BUILD_DIR

# Create the jniLibs build directory
JNI_DIR=jniLibs
mkdir -p $JNI_DIR

# Set up cargo-ndk
cargo install cargo-ndk
rustup target add \
        aarch64-linux-android \
        armv7-linux-androideabi \
        x86_64-linux-android \
        i686-linux-android

# Build the android libraries in the jniLibs directory
cargo ndk -o $JNI_DIR \
        --manifest-path ../Cargo.toml \
        -t armeabi-v7a \
        -t arm64-v8a \
        -t x86 \
        -t x86_64 \
        build --release 

# Archive the dynamic libs
cd $JNI_DIR
tar -czvf ../android.tar.gz *

cd -


if [ "$1" == "debug" ]; then
cp android.tar.gz ../packages/flutter_gpt_tokenizer/android/$DEBUGZIP
fi
echo "Build complete. $1 mode"

# Cleanup
rm -rf $JNI_DIR
