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
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.7.0/AmitySDK.xcframework.zip",
                    checksum: "bde50cc63e3642746c1ba7ed0ed27623d25a7ac6a4a570ae175c263efdd885e9"
                ),
        .binaryTarget(
                    name: "Realm",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.7.0/Realm.xcframework.zip",
                    checksum: "72a03ad875efe46a8e6ae953ae9bdc4ff1b0d6336fecb8af9758cc82f5db2f98"
                ),
         .binaryTarget(
                    name: "RealmSwift",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.7.0/RealmSwift.xcframework.zip",
                    checksum: "df7a5576d9a3bbba0af324b7d66de9cccea4068362b78ed1714ef2b3ff29d1a9"
                ),
        .binaryTarget(
                    name: "AmityLiveVideoBroadcastKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.7.0/AmityLiveVideoBroadcastKit.xcframework.zip",
                    checksum: "a2b14393982526cd3f38b2d7e4cb25c783f33eb81aed17f18deb855866416e3e"
                ),
        .binaryTarget(
                    name: "AmityVideoPlayerKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.7.0/AmityVideoPlayerKit.xcframework.zip",
                    checksum: "6ed0dcba539b2e3b1b37ce02c95123582570feb2059671d110b401578dd17931"
                ),
        .binaryTarget(
                    name: "MobileVLCKit",
                    url: "https://sdk.amity.co/sdk-release/ios-frameworks/6.8.0/MobileVLCKit.xcframework.zip",
                    checksum: "23224e65575cdc18314937efb1af0ce8791f1ed567440e52fb0b6e37621bb9f3"
                ),
    ]
)

