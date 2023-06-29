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
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.6.0/AmitySDK.xcframework.zip",
                    checksum: "1bf8900e6bc5a0b6f301106481c849ba8f4d0c3f761ee906e6df533eaccb9358"
                ),
        .binaryTarget(
                    name: "Realm",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.6.0/Realm.xcframework.zip",
                    checksum: "90bd316b7fc75c7780884b760aaa0ea56f9a0e8afbf1d0e5ad1b55065d870d49"
                ),
         .binaryTarget(
                    name: "RealmSwift",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.6.0/RealmSwift.xcframework.zip",
                    checksum: "baf6ce109920375cfc042e423ea2a5826b4646a15affd7cdbe2d6a2385bed18f"
                ),
        .binaryTarget(
                    name: "AmityLiveVideoBroadcastKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.6.0/AmityLiveVideoBroadcastKit.xcframework.zip",
                    checksum: "d42d0507d51dcef56b039c341db3b55e4920918f75e54fd079d2b3d9583b7872"
                ),
        .binaryTarget(
                    name: "AmityVideoPlayerKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.6.0/AmityVideoPlayerKit.xcframework.zip",
                    checksum: "e3b56158da242a8e18a8541310ac036eef34db1dcab0458854afb30cac65a9cc"
                ),
        .binaryTarget(
                    name: "MobileVLCKit",
                    url: "https://sdk.amity.co/sdk-release/ios-frameworks/6.8.0/MobileVLCKit.xcframework.zip",
                    checksum: "23224e65575cdc18314937efb1af0ce8791f1ed567440e52fb0b6e37621bb9f3"
                ),
    ]
)

