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
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.13.0/AmitySDK.xcframework.zip",
                    checksum: "d2a5a281f1024555c628ec90e44a2d0a74329c8e543ec96a25b51a3a7b1fa192"
                ),
        .binaryTarget(
                    name: "Realm",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.13.0/Realm.xcframework.zip",
                    checksum: "1356c78ce1a436f87ad3180cbcd5cd2b77ae5b2f58adf21cbfeaf0376bafe04b"
                ),
         .binaryTarget(
                    name: "RealmSwift",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.13.0/RealmSwift.xcframework.zip",
                    checksum: "4ccb32239de0d8a942d92ff0ba9fdd2e00b816d59af85add9ab9b77ab114d6b7"
                ),
        .binaryTarget(
                    name: "AmityLiveVideoBroadcastKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.13.0/AmityLiveVideoBroadcastKit.xcframework.zip",
                    checksum: "183d5907c4a77e5226c3ad0964d47d957dc735db70d7379c4ee05ac3d6c8bdba"
                ),
        .binaryTarget(
                    name: "AmityVideoPlayerKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.13.0/AmityVideoPlayerKit.xcframework.zip",
                    checksum: "a7d68cb8e75cbfbfe01f6ffbe730f765258bfecb5853df86764ec575e27b4803"
                ),
        .binaryTarget(
                    name: "MobileVLCKit",
                    url: "https://sdk.amity.co/sdk-release/ios-frameworks/6.8.0/MobileVLCKit.xcframework.zip",
                    checksum: "23224e65575cdc18314937efb1af0ce8791f1ed567440e52fb0b6e37621bb9f3"
                ),
    ]
)

