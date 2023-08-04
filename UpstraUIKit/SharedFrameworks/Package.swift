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
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/2.35.6/AmitySDK.xcframework.zip",
                    checksum: "9808a422cc78e40e8e5653d253ab591d85e0a7c43d4ed96bc0e6b9a33fc1789e"
                ),
        .binaryTarget(
                    name: "Realm",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/2.35.6/Realm.xcframework.zip",
                    checksum: "d9854bca58fea75e97bce648f3688ab789335c36b3edd6633c2270dca8e968ad"
                ),
        .binaryTarget(
                    name: "AmityLiveVideoBroadcastKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/2.35.6/AmityLiveVideoBroadcastKit.xcframework.zip",
                    checksum: "5a835d31b78dcc0858b85bdc02c95707c414941e2e4f6fd4ede7abf3c1dbaf7c"
                ),
        .binaryTarget(
                    name: "AmityVideoPlayerKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/2.35.6/AmityVideoPlayerKit.xcframework.zip",
                    checksum: "7d7867dfe2ce7bcebe780af030988bb5fa04331c5764d75541cd0bb0cab924b1"
                ),
        .binaryTarget(
                    name: "MobileVLCKit",
                    url: "https://s3-ap-southeast-1.amazonaws.com/ekosdk-release/ios-frameworks/5.1.0/MobileVLCKit.xcframework.zip",
                    checksum: "64e78ecdf0657246ac047b995d86a890a1c78852be968f5d80de2b28c90dc1a9"
                ),
    ]
)

