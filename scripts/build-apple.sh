#!/bin/bash
DEBUGZIP="gpt_tokenizer-v0.0.1.zip" # generated; do not edit
# Setup
BUILD_DIR=platform-build
mkdir $BUILD_DIR
cd $BUILD_DIR

# Build static libs
for TARGET in \
        aarch64-apple-ios x86_64-apple-ios aarch64-apple-ios-sim \
        x86_64-apple-darwin aarch64-apple-darwin
do
    rustup target add $TARGET
    cargo build -r --target=$TARGET
done

# Create XCFramework zip
FRAMEWORK="gpt_tokenizer.xcframework"
LIBNAME=libgpt_tokenizer.a
mkdir mac-lipo ios-sim-lipo
IOS_SIM_LIPO=ios-sim-lipo/$LIBNAME
MAC_LIPO=mac-lipo/$LIBNAME
lipo -create -output $IOS_SIM_LIPO \
        ../target/aarch64-apple-ios-sim/release/$LIBNAME \
        ../target/x86_64-apple-ios/release/$LIBNAME
lipo -create -output $MAC_LIPO \
        ../target/aarch64-apple-darwin/release/$LIBNAME \
        ../target/x86_64-apple-darwin/release/$LIBNAME
xcodebuild -create-xcframework \
        -library $IOS_SIM_LIPO \
        -library $MAC_LIPO \
        -library ../target/aarch64-apple-ios/release/$LIBNAME \
        -output $FRAMEWORK
zip -r $FRAMEWORK.zip $FRAMEWORK

if [ "$1" == "debug" ]; then
# copy debug zip for debuging locally
cp $FRAMEWORK.zip ../packages/flutter_gpt_tokenizer/ios/Frameworks/$DEBUGZIP
cp $FRAMEWORK.zip ../packages/flutter_gpt_tokenizer/macos/Frameworks/$DEBUGZIP
fi
echo "Build complete. $1 mode"




# Cleanup
rm -rf ios-sim-lipo mac-lipo $FRAMEWORK