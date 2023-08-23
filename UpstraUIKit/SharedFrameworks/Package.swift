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
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.10.1/AmitySDK.xcframework.zip",
                    checksum: "4d99ad59d79dc1715d3c8bfc82a89b25bc12cf26979c043d2b82696ac4f685a5"
                ),
        .binaryTarget(
                    name: "Realm",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.10.1/Realm.xcframework.zip",
                    checksum: "727a971a531a2520a5994a0bb17efde4dbd4b314895343161cdbfd8fbb7cf55e"
                ),
         .binaryTarget(
                    name: "RealmSwift",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.10.1/RealmSwift.xcframework.zip",
                    checksum: "bdae6ad4de14c395451d0d050df21de6b63a2f28068d72660e3c9d405ebc826c"
                ),
        .binaryTarget(
                    name: "AmityLiveVideoBroadcastKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.10.1/AmityLiveVideoBroadcastKit.xcframework.zip",
                    checksum: "8542109e5ecccc38e8ab7b2cfa4aa771b581768d33c354e4c4b68e6c9219c537"
                ),
        .binaryTarget(
                    name: "AmityVideoPlayerKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/3.10.1/AmityVideoPlayerKit.xcframework.zip",
                    checksum: "b8f5e0b5bcef52413c9f5e67905672984f675c950e7da6d7419b271c7c4c60f0"
                ),
        .binaryTarget(
                    name: "MobileVLCKit",
                    url: "https://sdk.amity.co/sdk-release/ios-frameworks/6.8.0/MobileVLCKit.xcframework.zip",
                    checksum: "23224e65575cdc18314937efb1af0ce8791f1ed567440e52fb0b6e37621bb9f3"
                ),
    ]
)

