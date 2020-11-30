//
//  EkoEventHandler.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 24/11/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

/// Global event handler for function overriding
///
/// Events which are interacted on UpstraUIKIt will trigger following functions
/// These all functions having its default behavior
///
/// - Parameter
///   - `source` uses to identify the class where the event come from
///   - `id` uses to identify the model we interacted with
///
/// - How it works?
///    1. A `userDidTap` function has been overriden
///    2. User avatar is tapped and `userDidTap` get called
///    3. Code within `userDidTap` get executed depends on what you write
///
open class EkoEventHandler {
    
    static var shared = EkoEventHandler()
    
    public init() { }
    
    /// Event for community
    /// It will be triggered when community avatar or community label is tapped
    ///
    /// A default behavior is navigating to `EkoCommunityProfilePageViewController`
    open func communityDidTap(from source: EkoViewController, communityId: String) {
        let viewController = EkoCommunityProfilePageViewController.make(withCommunityId: communityId)
        source.navigationController?.pushViewController(viewController, animated: true)
    }
    
    /// Event for channel
    /// It will be triggered when channel list is tapped
    ///
    /// A default behavior is navigating to `EkoMessageListViewController`
    open func channelDidTap(from source: EkoViewController, channelId: String) {
        let viewController = EkoMessageListViewController.make(channelId: channelId)
        source.navigationController?.pushViewController(viewController, animated: true)
    }
    
    /// Event for post
    /// It will be triggered when post or comment on feed is tapped
    ///
    /// A default behavior is navigating to `EkoPostDetailViewController`
    open func postDidtap(from source: EkoViewController, postId: String) {
        let viewController = EkoPostDetailViewController.make(postId: postId)
        source.navigationController?.pushViewController(viewController, animated: true)
    }

    /// Event for user
    /// It will be triggered when user avatar or user label is tapped
    ///
    /// A default behavior is navigating to `EkoUserProfilePageViewController`
    open func userDidTap(from source: EkoViewController, userId: String) {
        let viewController = EkoUserProfilePageViewController.make(withUserId: userId)
        source.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
