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
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.17.0/AmitySDK.xcframework.zip",
                    checksum: "ef4dc34c5c863febfaef73d9316356ba420ab35a489680791edd68e2cab57db3"
                ),
        .binaryTarget(
                    name: "Realm",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.17.0/Realm.xcframework.zip",
                    checksum: "650ecc463e4efd9b19b021880a312e0e3e2032bb96a5d10faad6b4330c4acbe2"
                ),
         .binaryTarget(
                    name: "RealmSwift",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.17.0/RealmSwift.xcframework.zip",
                    checksum: "6a1c33e33cc4ebbe70b1cad06020949b4f2f298157b3ca30bfe727a9d394dd45"
                ),
        .binaryTarget(
                    name: "AmityLiveVideoBroadcastKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.17.0/AmityLiveVideoBroadcastKit.xcframework.zip",
                    checksum: "1e22e024412f42e41b40f4cb73266f3a9f9c9d3618ba71bb3fc097c330d02e80"
                ),
        .binaryTarget(
                    name: "AmityVideoPlayerKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.17.0/AmityVideoPlayerKit.xcframework.zip",
                    checksum: "d7cf263462ba431b5d69615a6eeae224313c0a60423a301a03ec9005c0f5cdb4"
                ),
        .binaryTarget(
                    name: "MobileVLCKit",
                    url: "https://sdk.amity.co/sdk-release/ios-frameworks/6.8.0/MobileVLCKit.xcframework.zip",
                    checksum: "23224e65575cdc18314937efb1af0ce8791f1ed567440e52fb0b6e37621bb9f3"
                ),
    ]
)

