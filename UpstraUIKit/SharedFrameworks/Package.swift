// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SharedFrameworks",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SharedFrameworks",
            targets: ["SharedFrameworks", "AmitySDK", "Realm", "AmityLiveVideoBroadcastKit", "AmityVideoPlayerKit", "MobileVLCKit"]),
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
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/2.35.3/AmitySDK.xcframework.zip",
                    checksum: "7dc7261c7ccc37083c907ff3bcfe60e0fad64f361da81d6f31078bbc050a05d3"
                ),
        .binaryTarget(
                    name: "Realm",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/2.35.3/Realm.xcframework.zip",
                    checksum: "6ba3ef47eb011ca52b1ff78a243300a06807a84e6c56ce1415405685becb01f4"
                ),
        .binaryTarget(
                    name: "AmityLiveVideoBroadcastKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/2.35.3/AmityLiveVideoBroadcastKit.xcframework.zip",
                    checksum: "027cf46134e5358237dd689eab9a70aad12a09ad6595d88bfd4fb845586f49cc"
                ),
        .binaryTarget(
                    name: "AmityVideoPlayerKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/2.35.3/AmityVideoPlayerKit.xcframework.zip",
                    checksum: "fb4485ca3fa6f4a85cfd2c0560b4eab2749d3a29268c76dfab98eb7ad7916497"
                ),
        .binaryTarget(
                    name: "MobileVLCKit",
                    url: "https://s3-ap-southeast-1.amazonaws.com/ekosdk-release/ios-frameworks/5.1.0/MobileVLCKit.xcframework.zip",
                    checksum: "64e78ecdf0657246ac047b995d86a890a1c78852be968f5d80de2b28c90dc1a9"
                ),
    ]
)

