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
    /// It will be triggered when channel list or chat button is tapped
    ///
    /// A default behavior is navigating to `EkoMessageListViewController`
    open func channelDidTap(from source: EkoViewController, channelId: String) {
        let viewController = EkoMessageListViewController.make(channelId: channelId)
        source.navigationController?.pushViewController(viewController, animated: true)
    }
    
    /// Event for community channel
    /// It will be triggered when community  button tapped
    ///
    /// There is no default behavior yet. Please override and implement your own here.
    open func communityChannelDidTap(from source: EkoViewController, channelId: String) {
        // Internally left empty
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
    
    /// Event for edit user
    /// It will be triggered when edit user button is tapped
    ///
    /// A default behavior is navigating to `EkoEditUserProfileViewController`
    open func editUserDidTap(from source: EkoViewController, userId: String) {
        let editProfileViewController = EkoEditUserProfileViewController.make()
        source.navigationController?.pushViewController(editProfileViewController, animated: true)
    }
    
    /// Event for post creator
    /// It will be triggered when post button is tapped
    ///
    /// A default behavior is presenting or navigating to `EkoPostCreateViewController`
    open func createPostDidTap(from source: EkoViewController, postTarget: EkoPostTarget) {
        if source is EkoPostTargetSelectionViewController {
            let viewController = EkoPostCreateViewController.make(postTarget: postTarget)
            source.navigationController?.pushViewController(viewController, animated: true)
        } else {
            // When create button tapped, automatically navigate to post page with `myfeed` target.
            let viewController = EkoPostCreateViewController.make(postTarget: postTarget)
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .overFullScreen
            source.present(navigationController, animated: true, completion: nil)
        }
    }
    
    /// Event for post editor
    /// It will be triggered when edit post button is tapped
    ///
    /// A default behavior is presenting a `EkoPostEditViewController`
    open func editPostDidTap(from source: EkoViewController, postId: String) {
        let viewController = EkoPostEditViewController.make(withPostId: postId)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overFullScreen
        source.present(navigationController, animated: true, completion: nil)
    }
    
    /// Event to share a post
    /// It will be triggered when share button is tapped
    ///
    /// A default behavior is presenting a `EkoActivityController`
    open func sharePostDidTap(from source: EkoViewController, postId: String) {
        let viewController = EkoActivityController.make(activityItems: [postId])
        source.present(viewController, animated: true, completion: nil)
    }
}
