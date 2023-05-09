// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SharedFrameworks",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SharedFrameworks",
            targets: ["SharedFrameworks", "AmitySDK", "Realm", "RealmSwift", "AmityLiveVideoBroadcastKit", "AmityVideoPlayerKit", "MobileVLCKit"]),
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
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.2.0/AmitySDK.xcframework.zip",
                    checksum: "86770acd4eabc0ac6380a020657fad4c2829a50a1852261f76948ef70ce3afec"
                ),
        .binaryTarget(
                    name: "Realm",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.2.0/Realm.xcframework.zip",
                    checksum: "37eb4516d7ad6fd365cf7aadfba22858448f3f282feb01d106c169fcabeaa84f"
                ),
         .binaryTarget(
                    name: "RealmSwift",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.2.0/RealmSwift.xcframework.zip",
                    checksum: "e00b975b3f00ae801976e06dd5472a60a39e554a2b2c7daef00429d5caf226cb"
                ),
        .binaryTarget(
                    name: "AmityLiveVideoBroadcastKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.2.0/AmityLiveVideoBroadcastKit.xcframework.zip",
                    checksum: "d223782d6fa528806390bb1f3f81ebbed05c6dc1e29198421b135a07b5b56746"
                ),
        .binaryTarget(
                    name: "AmityVideoPlayerKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.2.0/AmityVideoPlayerKit.xcframework.zip",
                    checksum: "4e865ce4f53e7cc2667a8e7700c296d499dbf3876be511a923938b0a7940c5b5"
                ),
        .binaryTarget(
                    name: "MobileVLCKit",
                    url: "https://s3-ap-southeast-1.amazonaws.com/ekosdk-release/ios-frameworks/5.1.0/MobileVLCKit.xcframework.zip",
                    checksum: "64e78ecdf0657246ac047b995d86a890a1c78852be968f5d80de2b28c90dc1a9"
                ),
    ]
)

