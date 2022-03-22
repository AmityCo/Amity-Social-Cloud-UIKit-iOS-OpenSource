// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AmityUI-Noom",
    platforms: [ 
    	.iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AmityUI-Noom",
            targets: ["AmityUI-Noom"]),
    ],
    dependencies: [
        .package(
            name: "AmitySDK",
            url: "https://github.com/AmityCo/Amity-Social-Cloud-SDK-iOS-SwiftPM.git",
            from: "5.14.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AmityUI-Noom",
            dependencies: ["AmitySDK"],
            path: "UpstraUIKit/UpstraUIKit"
        ),
        .testTarget(
            name: "Amity-Social-Cloud-UIKit-iOS-OpenSourceTests",
            dependencies: ["Amity-Social-Cloud-UIKit-iOS-OpenSource"]),
    ]
)
