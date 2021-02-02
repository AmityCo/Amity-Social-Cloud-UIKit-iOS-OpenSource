
# UpstraUIKit

<p align="center" >
  <img src="https://uploads-ssl.webflow.com/5ee51b71187c830280662208/5eec9a674479b0e4de630ac2_upstra-logo.svg" alt="Upstra" title="UpstraSDK">
</p>

[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

UpstraUIKit is a delightful networking library for iOS. It is extending the powerful high-level messaging abstractions provided by [Eko](https://www.ekoapp.com/). It has a scalable architecture with well-designed, feature-rich APIs that are a joy to use.

## Requirements

| UpstraUIKit Version | EkoChatSDK Version | Minimum iOS Target  | Swift Version | Xcode Version |

| v1.9.0 | v4.4.0 | iOS 12.0 | Swift 5.3 | Xcode 12.2 |

## Dependencies

UpstraUIKit has dependencies with Realm. Currently we are only able to work with Realm version 4.x.x.

## Framework Building

UpstraUIKit supports building xcframework which can be used on any Xcode version. Please follow this instruction for building.
1. Open this project with Xcode 12.2 (The version should be the same)
2. Select `Release Framework` as a build target
3. Build (The output path is `/UpstraUIKit/Distribution`)

`Distribution` folder will contains `EkoChat.xcframework`, `Realm.xcframework` and `UpstraUIKit.xcframework`. These frameworks can be imported and built on any version of Xcode or Swift.

## Sample App

UpstraUIKit has sample app you can play along with it. It is written with Swift. Please finish `Release Framework` before running `SampleApp`.

## License

Public Framework. Copyright (c) 2020 [Amity](https://ekoapp.com).
