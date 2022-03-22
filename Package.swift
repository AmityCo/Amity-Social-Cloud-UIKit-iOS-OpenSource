// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Amity-Social-Cloud-UIKit-iOS-OpenSource",
    platforms: [ 
    	.iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Amity",
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
            path: "UpstraUIKit/UpstraUIKit",
            exclude: [
                "UpstraUIKit/UpstraUIKit/Modules/Community/Community Detail/EkoCommunityDetailViewController.swift",
                "UpstraUIKit/UpstraUIKit/Modules/Comunity/Category List/EkoCategorySelectionViewController.swift",
                "UpstraUIKit/UpstraUIKit/Modules/Comunity/Feed Posts/Scenes/Feed/Feed/EkoFeedController.swift",
                "UpstraUIKit/UpstraUIKit/Modules/Comunity/Notification Settings/Social Notification Settings/ViewController/EkoPostNotificationSettingsViewController.swift",
                "UpstraUIKit/UpstraUIKit/Modules/Comunity/Notification Settings/Social Notification Settings/ViewModel/EkoPostNotificationSettingsScreenViewModelType.swift",
                "UpstraUIKit/UpstraUIKit/Modules/Comunity/Post Creator/EkoCreatePostViewController.swift",
                "UpstraUIKit/UpstraUIKit/Modules/Comunity/Search/EkoSeachCommunitiesViewController.swift"
            ]
        ),
        .testTarget(
            name: "Amity-Social-Cloud-UIKit-iOS-OpenSourceTests",
            dependencies: ["Amity-Social-Cloud-UIKit-iOS-OpenSource"]),
    ]
)
