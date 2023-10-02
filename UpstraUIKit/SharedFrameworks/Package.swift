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
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.12.0/AmitySDK.xcframework.zip",
                    checksum: "9e516bf9371104b4db6fd0ae59792f9cc316bf49132dd8ce3ce5cf64ef9fe63d"
                ),
        .binaryTarget(
                    name: "Realm",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.12.0/Realm.xcframework.zip",
                    checksum: "a5e9e9910e019775fbf1e39ac8dc2d335b56b009cb144ea54f2a421c14f9f9fa"
                ),
         .binaryTarget(
                    name: "RealmSwift",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.12.0/RealmSwift.xcframework.zip",
                    checksum: "831dcaeae8c085d290d24cf5aa8fa06ca502e3687e18c6e5e013c096c3c7f4f3"
                ),
        .binaryTarget(
                    name: "AmityLiveVideoBroadcastKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.12.0/AmityLiveVideoBroadcastKit.xcframework.zip",
                    checksum: "f105fc5fa2722396b8d64bd1d03a62706d37b8938e2719ac837b0edceb9876f4"
                ),
        .binaryTarget(
                    name: "AmityVideoPlayerKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.12.0/AmityVideoPlayerKit.xcframework.zip",
                    checksum: "cfea987ca1515454f916e0e91cd660651fa4606525a8c0faa648136496bdec44"
                ),
        .binaryTarget(
                    name: "MobileVLCKit",
                    url: "https://sdk.amity.co/sdk-release/ios-frameworks/6.8.0/MobileVLCKit.xcframework.zip",
                    checksum: "23224e65575cdc18314937efb1af0ce8791f1ed567440e52fb0b6e37621bb9f3"
                ),
    ]
)

