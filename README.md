
# AmityUIKit OpenSource

<p align="center" >
  <img src="https://global-uploads.webflow.com/5eddccffdb3c6a27f79757c1/604f017e59681e734c3bd995_nav-logo.png" alt="Amity" title="AmityUIKit">
</p>

AmityUIKit is a delightful networking library for iOS. It is extending the powerful high-level messaging abstractions provided by [Amity](https://www.amity.co). It has a scalable architecture with well-designed, feature-rich APIs that are a joy to use.

## Requirements

| Minimum iOS Target | Supported Language |
| ------------------ | ------------------ |
| iOS 12.0           |        Swift 5.3   |

## Dependencies

AmityUIKit has dependencies with Realm. Currently we are only able to work with Realm version 10.12.0.

## Framework Building

AmityUIKit supports building xcframework which can be used on any Xcode version. Please follow this instruction for building.
1. Open this project with Xcode 12.2 (The version should be the same)
2. Select `Release Framework` as a build target
3. Build (The output path is `/AmityUIKit/Distribution`)

`Distribution` folder will contains `AmityChat.xcframework`, `Realm.xcframework` and `AmityUIKit.xcframework`. These frameworks can be imported and built on any version of Xcode or Swift.

## Sample App

AmityUIKit has sample app you can play along with it. It is written with Swift. Please finish `Release Framework` before running `SampleApp`.

## License

Public Framework. Copyright (c) 2020 [Amity](https://www.amity.co).
