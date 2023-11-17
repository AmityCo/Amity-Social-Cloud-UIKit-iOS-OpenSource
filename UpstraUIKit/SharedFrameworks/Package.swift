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
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.16.0/AmitySDK.xcframework.zip",
                    checksum: "47ddcfdd2c71e5ca190c8fbc884b556d4332e1a48c11c3ab7e58c54a30b5d703"
                ),
        .binaryTarget(
                    name: "Realm",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.16.0/Realm.xcframework.zip",
                    checksum: "9e0fb11d767b20d9115f298f16b13eeadee8150d68958c600b39b760ccb3de53"
                ),
         .binaryTarget(
                    name: "RealmSwift",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.16.0/RealmSwift.xcframework.zip",
                    checksum: "8fbc3e1e539905fd51b1e821f9343c38b686618f34ff1bddcb918354dffe7b7e"
                ),
        .binaryTarget(
                    name: "AmityLiveVideoBroadcastKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.16.0/AmityLiveVideoBroadcastKit.xcframework.zip",
                    checksum: "81926b18eaeb1ddd9e95cabc25ceb75ad3379748a6ce514bbd81d98b091bbf87"
                ),
        .binaryTarget(
                    name: "AmityVideoPlayerKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.16.0/AmityVideoPlayerKit.xcframework.zip",
                    checksum: "fb5f9d0108d17169ea1c33499841dcd88a21b02225083275a0267d055787d885"
                ),
        .binaryTarget(
                    name: "MobileVLCKit",
                    url: "https://sdk.amity.co/sdk-release/ios-frameworks/6.8.0/MobileVLCKit.xcframework.zip",
                    checksum: "23224e65575cdc18314937efb1af0ce8791f1ed567440e52fb0b6e37621bb9f3"
                ),
    ]
)

