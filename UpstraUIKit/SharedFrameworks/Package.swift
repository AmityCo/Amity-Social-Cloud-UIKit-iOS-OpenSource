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
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.3.0/AmitySDK.xcframework.zip",
                    checksum: "ef8489c5ee5d43fa40e3d9109b43f8e6572ee5eb657a0ce993f6a6f36985d56f"
                ),
        .binaryTarget(
                    name: "Realm",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.3.0/Realm.xcframework.zip",
                    checksum: "b92c70c6410777d47da8c32b2e3566d92ef0f875456d59f783b4b01617b6c781"
                ),
         .binaryTarget(
                    name: "RealmSwift",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.3.0/RealmSwift.xcframework.zip",
                    checksum: "3af410ba306bb92a1e2b4a7a2308c9f3d63a98cfa0b8df87ee94a55ae665786a"
                ),
        .binaryTarget(
                    name: "AmityLiveVideoBroadcastKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.3.0/AmityLiveVideoBroadcastKit.xcframework.zip",
                    checksum: "493e7964f5ac11c523d97f81de15972f3a46d938d3aae1bb7e60b4018ea4bf01"
                ),
        .binaryTarget(
                    name: "AmityVideoPlayerKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.3.0/AmityVideoPlayerKit.xcframework.zip",
                    checksum: "684d173cb781484d08720e49e39ae3629a5ceed87368fff25c832a94b164c8eb"
                ),
        .binaryTarget(
                    name: "MobileVLCKit",
                    url: "https://sdk.amity.co/sdk-release/ios-frameworks/6.8.0/MobileVLCKit.xcframework.zip",
                    checksum: "23224e65575cdc18314937efb1af0ce8791f1ed567440e52fb0b6e37621bb9f3"
                ),
    ]
)

