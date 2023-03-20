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
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/2.35.1/AmitySDK.xcframework.zip",
                    checksum: "86179c245dd652337b16811a2a6ca83fd4d004445d6e1a6c43d49faeb8c23ffb"
                ),
        .binaryTarget(
                    name: "Realm",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/2.35.1/Realm.xcframework.zip",
                    checksum: "ead808f7dece31d8f0a29f852cf6c1ad8488e61ed40e5c62ba79cdd5a0c54bbf"
                ),
        .binaryTarget(
                    name: "AmityLiveVideoBroadcastKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/2.35.1/AmityLiveVideoBroadcastKit.xcframework.zip",
                    checksum: "80673a8695a8b746cd0e4a37cd52d8d8439abb0aef6317d5c5b477f4a0fa5e04"
                ),
        .binaryTarget(
                    name: "AmityVideoPlayerKit",
                    url: "https://sdk.amity.co/sdk-release/ios-uikit-frameworks/2.35.1/AmityVideoPlayerKit.xcframework.zip",
                    checksum: "60557dd8741d9843b21292545f2341ec2ac5ab5146f8006d8785a3e5680ddae4"
                ),
        .binaryTarget(
                    name: "MobileVLCKit",
                    url: "https://s3-ap-southeast-1.amazonaws.com/ekosdk-release/ios-frameworks/5.1.0/MobileVLCKit.xcframework.zip",
                    checksum: "64e78ecdf0657246ac047b995d86a890a1c78852be968f5d80de2b28c90dc1a9"
                ),
    ]
)

