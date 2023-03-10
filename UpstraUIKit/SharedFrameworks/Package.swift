// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SharedFrameworks",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SharedFrameworks",
            targets: ["SharedFrameworks", "AmitySDK", "Realm", "AmityLiveVideoBroadcastKit", "AmityVideoPlayerKit", "MobileVLCKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SharedFrameworks",
            dependencies: []),
        .binaryTarget(
                    name: "AmitySDK",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/2.35.0/AmitySDK.xcframework.zip",
                    checksum: "501bd62acfc9ea25ced3f0f43b4c112f3c52c8975e4590ebb43ef502b9b3986e"
                ),
        .binaryTarget(
                    name: "Realm",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/2.35.0/Realm.xcframework.zip",
                    checksum: "e7d8ab5dbe644c5364559f21a30091193a12e9258f6fb237d2b6652eb6f07adb"
                ),
        .binaryTarget(
                    name: "AmityLiveVideoBroadcastKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/2.35.0/AmityLiveVideoBroadcastKit.xcframework.zip",
                    checksum: "b9356dd9adbd6cb7093333e5ecaf430fae798d218969d79f080f9000d20869e3"
                ),
        .binaryTarget(
                    name: "AmityVideoPlayerKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/2.35.0/AmityVideoPlayerKit.xcframework.zip",
                    checksum: "1e13b8d83c7ba12c2c38d713dfe3233f5d5544cf0109779bdc0ade93474f4f32"
                ),
        .binaryTarget(
                    name: "MobileVLCKit",
                    url: "https://s3-ap-southeast-1.amazonaws.com/ekosdk-release/ios-frameworks/5.1.0/MobileVLCKit.xcframework.zip",
                    checksum: "64e78ecdf0657246ac047b995d86a890a1c78852be968f5d80de2b28c90dc1a9"
                ),
    ]
)

