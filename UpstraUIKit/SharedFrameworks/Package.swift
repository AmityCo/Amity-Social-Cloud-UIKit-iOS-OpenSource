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
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.11.0/AmitySDK.xcframework.zip",
                    checksum: "d736c6b6cb1607957e0d280e87b9d1b8f77238d7ab944c9448cc6a40bbbd2db4"
                ),
        .binaryTarget(
                    name: "Realm",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.11.0/Realm.xcframework.zip",
                    checksum: "a1e9b8a76cf75a848a85c5b718febb69b3bd074ae5529e0e90203cbe9fbf7496"
                ),
         .binaryTarget(
                    name: "RealmSwift",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.11.0/RealmSwift.xcframework.zip",
                    checksum: "c91d401c8ee8fe2cf91c1744c24d5437fe04e01c275120f2cebdefbd461cafa0"
                ),
        .binaryTarget(
                    name: "AmityLiveVideoBroadcastKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.11.0/AmityLiveVideoBroadcastKit.xcframework.zip",
                    checksum: "9cbf6172d57ffd103de59b28bf0785e84b8148e89ae7e87c2dcd8ed8dac862f6"
                ),
        .binaryTarget(
                    name: "AmityVideoPlayerKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.11.0/AmityVideoPlayerKit.xcframework.zip",
                    checksum: "acad96573d5680bea666c118839ae079102cfd20dabccc175e2a1bb1c781b7e3"
                ),
        .binaryTarget(
                    name: "MobileVLCKit",
                    url: "https://sdk.amity.co/sdk-release/ios-frameworks/6.8.0/MobileVLCKit.xcframework.zip",
                    checksum: "23224e65575cdc18314937efb1af0ce8791f1ed567440e52fb0b6e37621bb9f3"
                ),
    ]
)

