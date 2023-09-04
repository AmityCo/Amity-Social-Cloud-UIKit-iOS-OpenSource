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
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.10.2/AmitySDK.xcframework.zip",
                    checksum: "588502e298fe6ac1aaa91be3c4ca2d224da23f9fb5aaaa2a2798429399d4dc9d"
                ),
        .binaryTarget(
                    name: "Realm",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.10.2/Realm.xcframework.zip",
                    checksum: "91b15ecdfd1c565fc41b0c373be9132a84f8a4478f5f3965f54d2bb7a12702dd"
                ),
         .binaryTarget(
                    name: "RealmSwift",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.10.2/RealmSwift.xcframework.zip",
                    checksum: "1992139b8931b937d9d2e772719488d8424728f1c40bfab5f0d018993e7feb43"
                ),
        .binaryTarget(
                    name: "AmityLiveVideoBroadcastKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.10.2/AmityLiveVideoBroadcastKit.xcframework.zip",
                    checksum: "840180ebad9e60fdca9347f99d35b1c87c1f564d57a9740c6bf7c67ee9c59c30"
                ),
        .binaryTarget(
                    name: "AmityVideoPlayerKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.10.2/AmityVideoPlayerKit.xcframework.zip",
                    checksum: "e1cbf93f98dcd12ee14172c92cd5e1def4219f34ee7a7ac2e1bdf284094ad4ff"
                ),
        .binaryTarget(
                    name: "MobileVLCKit",
                    url: "https://sdk.amity.co/sdk-release/ios-frameworks/6.8.0/MobileVLCKit.xcframework.zip",
                    checksum: "23224e65575cdc18314937efb1af0ce8791f1ed567440e52fb0b6e37621bb9f3"
                ),
    ]
)

