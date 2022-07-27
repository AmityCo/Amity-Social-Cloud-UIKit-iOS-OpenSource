//
//  AmityEventHandler.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 24/11/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK
import Photos

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
    
    public static var shared = AmityEventHandler()
    
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
            .viewControllers.last(where: { $0.isKind(of: AmityNewsfeedViewController.self)
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
    
    /// Event for selecting post target
    /// It will be triggered when the user choose target to create the post i.e their own feed or community feed.
    ///
    /// A default behavior is present post creator page, with the selected target.
    open func postTargetDidSelect(
        from source: AmityViewController,
        postTarget: AmityPostTarget,
        postContentType: AmityPostContentType,
        openByProfileTrueID: Bool = false
    ) {
        createPostDidTap(from: source, postTarget: postTarget, postContentType: postContentType, openByProfileTrueID: openByProfileTrueID)
    }
    
    open func postTargetDidSelectFromToday(
        from source: AmityViewController,
        postTarget: AmityPostTarget,
        postType: PostFromTodayType,
        openByProfileTrueID: Bool = false
    ) {
        createPostDidTapFromToday(from: source, postTarget: postTarget, postType: postType)
    }
    
    open func postTargetDidSelectFromGallery(
        from source: AmityViewController,
        postTarget: AmityPostTarget,
        openByProfileTrueID: Bool = false,
        asset: [PHAsset]
    ) {
        createPostDidTapFromGallery(from: source, postTarget: postTarget, asset: asset)
    }
        
    /// Event for post creator
    /// It will be triggered when post button is tapped
    ///
    /// If there is a `postTarget` passing into, immediately calls `postTargetDidSelect(:)`.
    /// If there isn't , navigate to `AmityPostTargetSelectionViewController`.
    open func createPostBeingPrepared(from source: AmityViewController, postTarget: AmityPostTarget? = nil, liveStreamPermission: Bool = false, openByProfileTrueID: Bool = false) {
        debugPrint("Open Profile ==> \(openByProfileTrueID)")
        let completion: ((AmityPostContentType) -> Void) = { postContentType in
            if let postTarget = postTarget {
                // show create post
                AmityEventHandler.shared.postTargetDidSelect(from: source, postTarget: postTarget, postContentType: postContentType, openByProfileTrueID: openByProfileTrueID)
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
            title: AmityLocalizedStringSet.LiveStream.Create.titleName.localizedString,
            image: UIImage(named: "icon_create_livestream_post", in: AmityUIKitManager.bundle, compatibleWith: nil)) {
                completion(.livestream)
            }
        
        if liveStreamPermission {
            AmityBottomSheet.present(options: [postOption, livestreamPost, pollPostOption], from: source)
        } else {
            AmityBottomSheet.present(options: [postOption, pollPostOption], from: source)
        }

    }
    
    /// Event for post creator
    /// It will be triggered after selecting post target
    ///
    /// The default behavior is presenting or navigating to post creation page, which depends on post content type.
    ///  - `AmityPostCreatorViewController` for post type
    ///  - `AmityPollCreatorViewController` for poll type
    open func createPostDidTap(from source: AmityViewController, postTarget: AmityPostTarget, postContentType: AmityPostContentType = .post, openByProfileTrueID: Bool) {
        
        var viewController: AmityViewController
        switch postContentType {
        case .post:
            viewController = AmityPostCreatorViewController.make(postTarget: postTarget)
        case .poll:
            viewController = AmityPollCreatorViewController.make(postTarget: postTarget)
        case .livestream:
            switch postTarget {
            case .myFeed:
                createLiveStreamPost(from: source, targetId: nil, targetType: .user, openByProfileTrueID: openByProfileTrueID, destinationToUnwindBackAfterFinish: source.presentingViewController ?? source)
            case .community(object: let community):
//                createLiveStreamPost(from: source, targetId: community.communityId, targetType: .community, destinationToUnwindBackAfterFinish: source.presentingViewController ?? source)
                createLiveStreamPost(from: source, targetId: community.communityId, targetType: .community, openByProfileTrueID: openByProfileTrueID, destinationToUnwindBackAfterFinish: source.presentingViewController ?? source)
            }
            return
        }
        
        if openByProfileTrueID {
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .overFullScreen
            source.present(navigationController, animated: true, completion: nil)
        } else {
            if source.isModalPresentation {
                // a source is presenting. push a new vc.
                if source.isKind(of: AmityPostTargetPickerViewController.self) {
                    source.navigationController?.pushViewController(viewController, animated: true)
                    return
                }
                
                if case .myFeed = postTarget {
                    source.navigationController?.pushViewController(viewController, animated: true)
                    return
                }
                
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.modalPresentationStyle = .overFullScreen
                source.present(navigationController, animated: true, completion: nil)
            } else {
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.modalPresentationStyle = .overFullScreen
                source.present(navigationController, animated: true, completion: nil)
            }
        }
        
    }
    
    open func createPostDidTapFromToday(from source: AmityViewController, postTarget: AmityPostTarget, postType: PostFromTodayType) {
        
        var viewController: AmityViewController
        switch postType {
        case .generic:
            viewController = AmityPostCreatorViewController.make(postTarget: postTarget, postType: postType)
            source.navigationController?.pushViewController(viewController, animated: true)
        case .camera:
            viewController = AmityPostCreatorViewController.make(postTarget: postTarget, postType: postType)
            source.navigationController?.pushViewController(viewController, animated: true)
        case .photo:
            viewController = AmityPostCreatorViewController.make(postTarget: postTarget, postType: postType)
            source.navigationController?.pushViewController(viewController, animated: true)
        case .video:
            viewController = AmityPostCreatorViewController.make(postTarget: postTarget, postType: postType)
            source.navigationController?.pushViewController(viewController, animated: true)
        case .poll:
            viewController = AmityPollCreatorViewController.make(postTarget: postTarget, postType: postType)
            source.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    open func createPostDidTapFromGallery(from source: AmityViewController, postTarget: AmityPostTarget, asset: [PHAsset]) {
        
        var viewController: AmityViewController
        viewController = AmityPostCreatorViewController.make(postTarget: postTarget, asset: asset)
        source.navigationController?.pushViewController(viewController, animated: true)
        
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
        openByProfileTrueID: Bool,
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
    open func openLiveStreamPlayer(from source: AmityViewController, postId: String, streamId: String, post: AmityPost) {
        print("To present live stream, please override \(AmityEventHandler.self).\(#function), see https://docs.amity.co for more details.")
    }
    
    open func openRecordedLiveStreamPlayer(
        from source: AmityViewController,
        postId: String,
        streamId: String,
        recordedData: [AmityLiveVideoRecordingData]
    ) {
        guard
            let firstRecordedData = recordedData.first,
            let videoUrl = firstRecordedData.url(for: .MP4) else {
            assertionFailure("recordedData must have at least one recorded data.")
            return
        }
        source.presentVideoPlayer(at: videoUrl)
    }
    /// TrueID Project
    open func shareCommunityPostDidTap(from source: UIViewController, title: String?, postId: String, communityId: String) {}
    open func shareCommunityProfileDidTap(from source: UIViewController, communityModelExternal: AmityCommunityModelExternal) {}
    open func shareLiveStreamDidTap(from source: UIViewController, amityPost: AmityPost? = nil) {}
    
    /// TrueID Detect Close view
    open func closeAmityCommunityViewController() {}
    
    /// TrueID Scroll Profile Detect
    open func timelineFeedDidScroll(_ scrollView: UIScrollView) {}
    open func galleryDidScroll(_ scrollView: UIScrollView) {}
    
    /// TrueID Scroll Home Detect
    open func homeCommunityDidScroll(_ scrollView: UIScrollView) {}
    
    /// TrueID ScanQRCode Seartch Tapped
    open func homeCommunityScanQRCodeTapped() {}
    
    /// TrueID Set URL Advertisement
    open func setURLAdvertisement(_ url: String) {}
    
    /// TrueID finish post from Today
    open func finishPostEvent(_ success: Bool, userId: String) {}
    
    /// TrueID route to newsfeed from recent hat
    open func routeToNewsfeedDidTap(from source: UIViewController) {}

    /// TrueID open contact page
    open func openContactPageEvent() {}
    
    //MARK: - AnalyticNCCEvent
    open func communityTopbarSearchTracking() {}
    open func communityTopbarProfileTracking() {}
    open func communityExploreButtonTracking() {}
    open func communityMyCommunitySectionTracking() {}
    open func communityCreatePostButtonTracking(screenName: String) {}
    open func communityJoinButtonTracking(screenName: String, communityModel: AmityCommunityModelExternal) {}
    open func communityJoinButtonTracking(screenName: String) {}
    open func communityDetailSectionTracking(screenName: String) {}
    open func communityAllCategoryButtonTracking() {}
    open func communityCategoryButtonTracking(screenName: String, categoryName: String) {}
    open func communityRecommendSectionTracking() {}
    open func communityEditProfileButtonTracking() {}
    open func communitySaveEditProfileButtonTracking() {}
    open func communityHomeButtonBarPagerTracking(tabName: String) {}
    open func communityCategorySeeMoreButtonTracking(titleOfSelf: String) {}
    
    // MARK: - AnalyticNCCScreen
    open func communityToExploreTracking() {}
    open func communityToNewsfeedTracking() {}
    open func communityCategoryListTracking() {}
    open func communityPageToTimelineTracking() {}
    open func communityUserProfileToTimelineTracking() {}
    open func communityCategoryNameListTracking(categoryName: String) {}
    
    
    
}
