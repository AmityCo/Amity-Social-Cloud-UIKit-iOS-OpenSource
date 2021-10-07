//
//  AmityEventHandler.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 24/11/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

/// Global event handler for function overriding
///
/// Events which are interacted on AmityUIKIt will trigger following functions
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
open class AmityEventHandler {
    
    static var shared = AmityEventHandler()
    
    public init() { }
    
    /// Event for community
    /// It will be triggered when community avatar or community label is tapped
    ///
    /// A default behavior is navigating to `AmityCommunityProfilePageViewController`
    open func communityDidTap(from source: AmityViewController, communityId: String) {
        let viewController = AmityCommunityProfilePageViewController.make(withCommunityId: communityId)
        source.navigationController?.pushViewController(viewController, animated: true)
    }
    
    /// Event for leave community
    /// It will be triggered when leave community button tapped
    ///
    /// A default behavior is popping to `AmityCommunityHomePageViewController`, `AmityNewsfeedViewController`.or `AmityFeedViewController`.
    /// If any of them doesn't exsist, popping to previous page.
    open func leaveCommunityDidTap(from source: AmityViewController, communityId: String) {
        if let vc = source.navigationController?
            .viewControllers.last(where: { $0.isKind(of: AmityCommunityHomePageViewController.self)
                                    || $0.isKind(of: AmityNewsfeedViewController.self)
                                    || $0.isKind(of: AmityFeedViewController.self) }) {
            source.navigationController?.popToViewController(vc, animated: true)
            return
        }
        source.navigationController?.popViewController(animated: true)
    }
    
    /// Event for community channel
    /// It will be triggered when community  button tapped
    ///
    /// There is no default behavior yet. Please override and implement your own here.
    open func communityChannelDidTap(from source: AmityViewController, channelId: String) {
        // Intentionally left empty
    }
    
    /// Event for post
    /// It will be triggered when post or comment on feed is tapped
    ///
    /// A default behavior is navigating to `AmityPostDetailViewController`
    open func postDidtap(from source: AmityViewController, postId: String) {
        // if post is tapped from AmityPostDetailViewController, ignores the event to avoid page stacking.
        guard !(source is AmityPostDetailViewController) else { return }
        
        let viewController = AmityPostDetailViewController.make(withPostId: postId)
        source.navigationController?.pushViewController(viewController, animated: true)
    }

    /// Event for user
    /// It will be triggered when user avatar or user label is tapped
    ///
    /// A default behavior is navigating to `AmityUserProfilePageViewController`
    open func userDidTap(from source: AmityViewController, userId: String) {
        let viewController = AmityUserProfilePageViewController.make(withUserId: userId)
        source.navigationController?.pushViewController(viewController, animated: true)
    }
    
    /// Event for edit user
    /// It will be triggered when edit user button is tapped
    ///
    /// A default behavior is navigating to `AmityEditUserProfileViewController`
    open func editUserDidTap(from source: AmityViewController, userId: String) {
        let editProfileViewController = AmityUserProfileEditorViewController.make()
        source.navigationController?.pushViewController(editProfileViewController, animated: true)
    }
    
    /// Event for post creator
    /// It will be triggered when post button is tapped
    ///
    /// A default behavior is presenting or navigating to `AmityPostTargetSelectionViewController`
    open func createPostDidTap(from source: AmityViewController, postTarget: AmityPostTarget) {
        if source is AmityPostTargetPickerViewController {
            let viewController = AmityPostCreatorViewController.make(postTarget: postTarget)
            source.navigationController?.pushViewController(viewController, animated: true)
        } else {
            // When create button tapped, automatically navigate to post page with `myfeed` target.
            let viewController = AmityPostCreatorViewController.make(postTarget: postTarget)
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .overFullScreen
            source.present(navigationController, animated: true, completion: nil)
        }
    }
    
    /// Event for post editor
    /// It will be triggered when edit post button is tapped
    ///
    /// A default behavior is presenting a `AmityPostEditViewController`
    open func editPostDidTap(from source: AmityViewController, postId: String) {
        let viewController = AmityPostEditorViewController.make(withPostId: postId)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overFullScreen
        source.present(navigationController, animated: true, completion: nil)
    }
    
    /// TrueID Project
    open func shareCommunityPostDidTap(from source: UIViewController, title: String?, postId: String, communityId: String) {}
    open func shareCommunityProfileDidTap(from source: UIViewController, communityModelExternal: AmityCommunityModelExternal) {}
}
