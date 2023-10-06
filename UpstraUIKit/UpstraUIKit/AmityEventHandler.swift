//
//  AmityEventHandler.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 24/11/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

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

public enum AmityPostContentType {
    case post
    case poll
    case livestream
}

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
    open func communityChannelDidTap(from source: AmityViewController, channelId: String, subChannelId: String) {
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
    
    /// Event for selecting post target
    /// It will be triggered when the user choose target to create the post i.e their own feed or community feed.
    ///
    /// A default behavior is present post creator page, with the selected target.
    open func postTargetDidSelect(
        from source: AmityViewController,
        postTarget: AmityPostTarget,
        postContentType: AmityPostContentType
    ) {
        createPostDidTap(from: source, postTarget: postTarget, postContentType: postContentType)
    }
        
    /// Event for post creator
    /// It will be triggered when post button is tapped
    ///
    /// If there is a `postTarget` passing into, immediately calls `postTargetDidSelect(:)`.
    /// If there isn't , navigate to `AmityPostTargetSelectionViewController`.
    open func createPostBeingPrepared(from source: AmityViewController, postTarget: AmityPostTarget? = nil) {
        let completion: ((AmityPostContentType) -> Void) = { postContentType in
            if let postTarget = postTarget {
                // show create post
                AmityEventHandler.shared.postTargetDidSelect(from: source, postTarget: postTarget, postContentType: postContentType)
            } else {
                // show post target picker
                let postTargetVC = AmityPostTargetPickerViewController.make(postContentType: postContentType)
                let navPostTargetVC = UINavigationController(rootViewController: postTargetVC)
                navPostTargetVC.modalPresentationStyle = .fullScreen
                source.present(navPostTargetVC, animated: true, completion: nil)
            }
        }
        
        // present bottom sheet
        let postOption = ImageItemOption(title: AmityLocalizedStringSet.General.post.localizedString, image: AmityIconSet.CreatePost.iconPost) {
            completion(.post)
        }
        let pollPostOption = ImageItemOption(title: AmityLocalizedStringSet.General.poll.localizedString, image: AmityIconSet.CreatePost.iconPoll) {
            completion(.poll)
        }
        
        let livestreamPost = ImageItemOption(
            title: "Livestream",
            image: UIImage(named: "icon_create_livestream_post", in: AmityUIKitManager.bundle, compatibleWith: nil)) {
                completion(.livestream)
            }
        
        AmityBottomSheet.present(options: [livestreamPost, postOption, pollPostOption], from: source)
    }
    
    /// Event for post creator
    /// It will be triggered after selecting post target
    ///
    /// The default behavior is presenting or navigating to post creation page, which depends on post content type.
    ///  - `AmityPostCreatorViewController` for post type
    ///  - `AmityPollCreatorViewController` for poll type
    open func createPostDidTap(from source: AmityViewController, postTarget: AmityPostTarget, postContentType: AmityPostContentType = .post) {
        
        var viewController: AmityViewController
        switch postContentType {
        case .post:
            viewController = AmityPostCreatorViewController.make(postTarget: postTarget)
        case .poll:
            viewController = AmityPollCreatorViewController.make(postTarget: postTarget)
        case .livestream:
            switch postTarget {
            case .myFeed:
                createLiveStreamPost(from: source, targetId: nil, targetType: .user, destinationToUnwindBackAfterFinish: source.presentingViewController ?? source)
            case .community(object: let community):
                createLiveStreamPost(from: source, targetId: community.communityId, targetType: .community, destinationToUnwindBackAfterFinish: source.presentingViewController ?? source)
            }
            return
        }
        
        if source.isModalPresentation {
            // a source is presenting. push a new vc.
            source.navigationController?.pushViewController(viewController, animated: true)
        } else {
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .overFullScreen
            source.present(navigationController, animated: true, completion: nil)
        }
    }
    
    /// This function will triggered when the user choose to "create live stream post".
    ///
    /// - Parameters:
    ///   - source: The source view controller that trigger the event.
    ///   - targetId: The target id to create live stream post.
    ///   - targetType: The target type to create live stream post.
    ///   - destinationToUnwindBackAfterFinish: The view controller to unwind back when live streaming has done. To maintain the proper AmityUIKit flow, please dismiss to this view controller after the action has ended.
    open func createLiveStreamPost(
        from source: AmityViewController,
        targetId: String?,
        targetType: AmityPostTargetType,
        destinationToUnwindBackAfterFinish: UIViewController
    ) {
        print("To present live stream post creator, please override \(AmityEventHandler.self).\(#function), see https://docs.amity.co for more details.")
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
    
    /// This function will triggered when the user tap to watch live stream.
    ///
    /// - Parameters:
    ///   - source: The source view controller that trigger the event.
    ///   - postId: The post id to watch the live stream.
    ///   - streamId: The stream id to watch.
    open func openLiveStreamPlayer(from source: AmityViewController, postId: String, streamId: String) {
        print("To present live stream, please override \(AmityEventHandler.self).\(#function), see https://docs.amity.co for more details.")
    }
    
    open func openRecordedLiveStreamPlayer(
        from source: AmityViewController,
        postId: String,
        stream: AmityStream
    ) {
        print("To watch recorded live stream videos, please override \(AmityEventHandler.self).\(#function), see https://docs.amity.co/amity-sdk/video/ios/view-play for more details.")
    }
}
