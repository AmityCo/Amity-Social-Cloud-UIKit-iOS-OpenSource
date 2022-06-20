// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AmityUIKit",
    platforms: [
            .iOS(.v13)
        ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AmityUIKit",
            targets: ["AmityUIKit"]),
    ],
    dependencies: [
        .package(
            name: "AmitySDK",
            url: "https://github.com/AmityCo/Amity-Social-Cloud-SDK-iOS-SwiftPM.git",
            from: "5.14.0")
    ],
    targets: [
        .target(
            name: "AmityUIKit",
            dependencies: ["AmitySDK"],
            path: "UpstraUIKit/UpstraUIKit",
            resources: [
                .process("Localization/AmityLocalizable.strings")
            ]
        )
    ]
)
