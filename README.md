# AmityUIKit OpenSource

Our **AmityUIKit** include user interfaces to enable fast integration of standard 
Amity Chat and Amity Social features into new or existing applications.

<img width="928" alt="Screen Shot 2564-11-22 at 08 29 57" src="https://user-images.githubusercontent.com/9884138/142821262-aab24859-68a6-45fe-a94f-3cd3a679b0ee.png">
<img width="897" alt="Screen Shot 2564-11-22 at 08 30 03" src="https://user-images.githubusercontent.com/9884138/142821272-cf46e2c6-9963-4b90-85ed-274ccc820756.png">

## Overview Architecture
**MVVM** is cleanly separates presentation layer from the other layers. Divorcing one from the other improves its maintainability and testability. It also makes the application evolution easier in the future, thereby reducing the risk of technological obsolescence. 

Eliminates the need for application redesign user interfaces become outdated, or even add more complexity in the specific layer.
For example, adding local data source to the application could be impacts to the other layers.

Please note that every view model in this project will be named as **screen view model**, e.g. `AmityFeedScreenViewModel` and `AmityRecentChatScreenViewModel`.


## Building framework
AmityUIKit supports building xcframework which can be used on any Xcode version. Please follow this instruction for building.
1. In terminal, go to project directory
2. Run "./scripts/release-uikit.sh"
3. After building process is done, there will be `amity-uikit.zip` file

`amity-uikit.zip` contains AmityChat.xcframework, Realm.xcframework and AmityUIKit.xcframework.

## Documentation
View the [documentation](https://github.com/AmityCo/Amity-Social-Cloud-UIKit-iOS-OpenSource/wiki) for AmityUIKit.


## Changelog
[See the changelog](https://github.com/AmityCo/Amity-Social-Cloud-UIKit-iOS/releases) to be aware of latest improvements and fixes.


## Contribution guidelines
Please refer to the [guidelines](https://github.com/AmityCo/Amity-Social-Cloud-UIKit-iOS-OpenSource/wiki/Contributing-to-Amity-UIKit-Open-Source).


## License
Public Framework. Copyright (c) 2020 [Amity](https://www.amity.co/).
