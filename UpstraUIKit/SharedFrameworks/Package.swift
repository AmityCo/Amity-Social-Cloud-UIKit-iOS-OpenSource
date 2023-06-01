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
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.4.0/AmitySDK.xcframework.zip",
                    checksum: "bd1d62c1c39d5099fc97deadc95757da839d0c0c1ae4534abe766c6ba502221e"
                ),
        .binaryTarget(
                    name: "Realm",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.4.0/Realm.xcframework.zip",
                    checksum: "db20857d4e9dc5f0634fafb05d57e2ab00d61702b5d3338d14d6f47e39bcbb5b"
                ),
         .binaryTarget(
                    name: "RealmSwift",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.4.0/RealmSwift.xcframework.zip",
                    checksum: "1ec2e4069a4d3ab5f30c6467ec1f4577605ebf19287f82cad23cc1ff912a2ce6"
                ),
        .binaryTarget(
                    name: "AmityLiveVideoBroadcastKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.4.0/AmityLiveVideoBroadcastKit.xcframework.zip",
                    checksum: "9012f794073e01a907e02cda538700c40f8a145419f66fc47a9079c9b9be4dd7"
                ),
        .binaryTarget(
                    name: "AmityVideoPlayerKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.4.0/AmityVideoPlayerKit.xcframework.zip",
                    checksum: "cc732bd2a38779bc9efac83276bede0c61249d5105a93d620fa85258e04185de"
                ),
        .binaryTarget(
                    name: "MobileVLCKit",
                    url: "https://sdk.amity.co/sdk-release/ios-frameworks/6.8.0/MobileVLCKit.xcframework.zip",
                    checksum: "23224e65575cdc18314937efb1af0ce8791f1ed567440e52fb0b6e37621bb9f3"
                ),
    ]
)

