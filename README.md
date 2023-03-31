- `cargo build` only re-run `tokenizer/build.rs` when the symbols are changed
- `cocopods 1.12.0` supports `slice_type: .dylib`. see [github](https://github.com/CocoaPods/CocoaPods/blob/master/lib/cocoapods/xcode/xcframework/xcframework_slice.rb#L63-L77)

- `build-apple.sh`
  - if `LIBNAME=libgpt_tokenizer.a`, everything works well
