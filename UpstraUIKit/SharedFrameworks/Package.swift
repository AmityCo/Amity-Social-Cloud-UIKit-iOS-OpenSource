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
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.6.1/AmitySDK.xcframework.zip",
                    checksum: "13fb863146020d1ab0cd4852e959cb8d9e26a5aa7c7f199b6d94473a9696a1ce"
                ),
        .binaryTarget(
                    name: "Realm",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.6.1/Realm.xcframework.zip",
                    checksum: "5bf26188800fff0ff6e0e3464f1f959bbd4fd5371f14bd0a997f9b7ee477ad79"
                ),
         .binaryTarget(
                    name: "RealmSwift",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.6.1/RealmSwift.xcframework.zip",
                    checksum: "48dc303dbf933ec382dba8a5f2fc25899889d7857d8bbd3599206f04fe49edfe"
                ),
        .binaryTarget(
                    name: "AmityLiveVideoBroadcastKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.6.1/AmityLiveVideoBroadcastKit.xcframework.zip",
                    checksum: "eb5b73b6e874827d1c6595fa370a963e2f377c9cc28cbd7efc196edbd2dd7369"
                ),
        .binaryTarget(
                    name: "AmityVideoPlayerKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.6.1/AmityVideoPlayerKit.xcframework.zip",
                    checksum: "e07902d34cc78e288167d92ea665145abe20ac24accd5240be075ca5e1441b35"
                ),
        .binaryTarget(
                    name: "MobileVLCKit",
                    url: "https://sdk.amity.co/sdk-release/ios-frameworks/6.8.0/MobileVLCKit.xcframework.zip",
                    checksum: "23224e65575cdc18314937efb1af0ce8791f1ed567440e52fb0b6e37621bb9f3"
                ),
    ]
)

