<img align="right"
src="https://user-images.githubusercontent.com/100549875/155941445-b1830713-5f9f-4903-9383-f36053a0775b.png"
alt="Amity Social Cloud SDKs" width="50%" />

<img align="left"
src="https://user-images.githubusercontent.com/100549875/155947065-3cc4291c-d600-40a1-bc49-4ff5e9b9d1be.svg"
alt="Amity logo" width="120px" />

<br />
<br />

# Amity Social Cloud SDKs
Boost app engagement and grow your user base with plug-and-play social
features. Amity modules are <b>ready to use</b> — the only things left
to do are integration and frontend.

Learn more about Amity here: [amity.co→](https://amity.co/)

<br />
<br />


# AmityUIKit OpenSource

Our **AmityUIKit** include user interfaces to enable fast integration of standard 
Amity Chat and Amity Social features into new or existing applications.

<img width="928" alt="Screen Shot 2564-11-22 at 08 29 57" src="https://user-images.githubusercontent.com/9884138/142821262-aab24859-68a6-45fe-a94f-3cd3a679b0ee.png">
<img width="897" alt="Screen Shot 2564-11-22 at 08 30 03" src="https://user-images.githubusercontent.com/9884138/142821272-cf46e2c6-9963-4b90-85ed-274ccc820756.png">

<br />

## Overview Architecture
**MVVM** is cleanly separates presentation layer from the other layers. Divorcing one from the other improves its maintainability and testability. It also makes the application evolution easier in the future, thereby reducing the risk of technological obsolescence. 

Eliminates the need for application redesign user interfaces become outdated, or even add more complexity in the specific layer.
For example, adding local data source to the application could be impacts to the other layers.

Please note that every view model in this project will be named as **screen view model**, e.g. `AmityFeedScreenViewModel` and `AmityRecentChatScreenViewModel`.

<br />

## Installation

### For latest UIKit releases `> 2.35.0`

AmityUIKit links with other dependencies such as `AmitySDK`, `Realm`, `RealmSwift` etc through `SharedFrameworks` which is a Swift Package.When you clone the project for the first time, all of this should be already setup for you. 

To run sample app:
- Simply build `AmityUIKit` target & then build `SampleApp` target and you would be able to run the sample project.

If you encounter any issues, you can 

- Reset `Sample App` project package cache. 
- Make sure `SharedFrameworks` and `AmityUIKit.framework` is linked in Sample App.

If you want to integrate this open sourced codebase to your existing project, please follow the installation steps provided in our documentation. [Installation Steps](https://docs.amity.co/uikit/ios/ios-uikit-installation-guide#_bln34rs78cz) 


### For older UIKit releases `< 2.35.0`:

As our older version of UIKit depends upon git lfs, please run the following command before building framework or running sample app.

```
git lfs fetch
```

Then, run the following command.
```
git lfs pull
```

<br />

## Building framework
AmityUIKit supports building xcframework which can be used on any Xcode version. Please follow this instruction for building.
1. In terminal, go to project directory
2. Run "./scripts/release-uikit.sh"
3. After building process is done, there will be `amity-uikit.zip` file

`amity-uikit.zip` contains AmityChat.xcframework, Realm.xcframework and AmityUIKit.xcframework.

<br />

## Documentation
View the [documentation](https://github.com/AmityCo/Amity-Social-Cloud-UIKit-iOS-OpenSource/wiki) for AmityUIKit.

<br />

## Changelog
[See the changelog](https://github.com/AmityCo/Amity-Social-Cloud-UIKit-iOS/releases) to be aware of latest improvements and fixes.

<br />

## Contribution guidelines
Please refer to the [guidelines](https://github.com/AmityCo/Amity-Social-Cloud-UIKit-iOS-OpenSource/wiki/Contributing-to-Amity-UIKit-Open-Source).


<br />
<br />

<img align="left"
src="https://user-images.githubusercontent.com/100549875/156137190-46c08727-042b-4f3d-858b-d50868ebb0b3.png"
alt="Amity Social Cloud SDKs" width="50%" />

## Resources

**Developer Portal** <br />
Learn about building, deploying, and managing Amity Social Cloud. <br />
[Portal→](https://www.amity.co/developer-portal)

**Documentation** <br />
Everything you need to integrate Amity Social Cloud. <br />
[Docs→](https://docs.amity.co/)

**Developer Kits** <br />
Explore Amity Social Cloud UI Kits and Template Apps. <br />
[Developer Kits→](https://www.amity.co/developer-kits)

**Community** <br />
Join the community of Amity Social Cloud developers. <br />
[Community→](https://community.amity.co/)

**FAQ** <br />
Get the answers to the most asked questions. <br />
[FAQ→](https://www.amity.co/faq)

<br />
<br />
<br />
<br />
<br />
<br />

## Amity Chat SDK
Amity Chat SDK is an easy-to-integrate solution that enables
high-performing chat services on your app. From one-on-one to
large-scale group messaging, power them with <b>Amity Chat SDK</b>,
built with <b>messaging service APIs</b> to ignite connections and
open discussions.

Learn more about Amity Chat on [our
website→](https://www.amity.co/chat) or view the Amity
Chat [Docs→](https://docs.amity.co/chat)

<br />

## Amity Social SDK
Get in-app communities up and running using Amity Social SDK. Enable
<b>plug-and-play social features using supercharged social APIs</b>
and see preference-based groups thrive within your platform.

Learn more about Amity Social on [our
website→](https://www.amity.co/social) or view the
Amity Social [Docs→](https://docs.amity.co/social)

<br />

## Amity Video SDK
The Amity Video SDK, powered by <b>video APIs</b>, elevates your
application's user experience by adding interactive features such as
<b>in-app Stories and Live Streaming</b>. Engage your users with
captivating, memorable virtual events to participate in along with
other viewers from around the world.

Learn more about Amity Video on [our
website→](https://www.amity.co/video) or view the Amity
Video [Docs→](https://docs.amity.co/video)

<br />

## About Amity
The future is social — and we at Amity are on a mission to make social
experiences more accessible than ever. Amity Social Cloud allows
companies to easily integrate plug-and-play social features into their
apps and digital channels to drive engagement, build communities, and
grow revenue.

<b>🟢 We're hiring!</b> View all [open positions→](https://www.amity.co/careers)

<br />

## License
Public Framework. Copyright © 2022 Amity.
