//
//  CustomEventHandler.swift
//  SampleApp
//
//  Created by Nontapat Siengsanor on 22/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit
import AmityUIKit
import AmitySDK
#if canImport(AmityUIKitLiveStream)
import AmityUIKitLiveStream
#endif

class AmityCustomEventHandler: AmityEventHandler {
    
    override func userDidTap(from source: AmityViewController, userId: String) {

        let settings = AmityUserProfilePageSettings()
        settings.shouldChatButtonHide = false
        
        let viewController = AmityUserProfilePageViewController.make(withUserId: userId, settings: settings)
        source.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func communityDidTap(from source: AmityViewController, communityId: String) {
        
        let settings = AmityCommunityProfilePageSettings()
        settings.shouldChatButtonHide = false
        
        let viewController = AmityCommunityProfilePageViewController.make(withCommunityId: communityId, settings: settings)
        source.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func communityChannelDidTap(from source: AmityViewController, channelId: String) {
        var settings = AmityMessageListViewController.Settings()
        settings.shouldShowChatSettingBarButton = true
        let viewController = AmityMessageListViewController.make(channelId: channelId, settings: settings)
        source.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func postDidtap(from source: AmityViewController, postId: String) {
        let vc = AmityPostDetailViewController.make(withPostId: postId)
        source.navigationController?.pushViewController(vc, animated: true)
    }
    
//    override func createPostDidTap(from source: AmityViewController, postTarget: AmityPostTarget, postContentType: AmityPostContentType = .post) {
//        var viewController: AmityViewController
//        switch postContentType {
//        case .post:
//            let settings = AmityPostEditorSettings()
//            viewController = AmityPostCreatorViewController.make(postTarget: postTarget, settings: settings)
//        case .poll:
//            viewController = AmityPollCreatorViewController.make(postTarget: postTarget)
//
//        @unknown default:
//            super.createPostDidTap(from: source, postTarget: postTarget, postContentType: postContentType, openByProfileTrueID: false)
//            return
//        }
//        
//        if source.isModalPresentation {
//            source.navigationController?.pushViewController(viewController, animated: true)
//        } else {
//            let navigationController = UINavigationController(rootViewController: viewController)
//            navigationController.modalPresentationStyle = .overFullScreen
//            source.present(navigationController, animated: true, completion: nil)
//        }
//    }
    
//    override func createLiveStreamPost(
//        from source: AmityViewController,
//        targetId: String?,
//        targetType: AmityPostTargetType,
//        destinationToUnwindBackAfterFinish: UIViewController
//    ) {
//
//        #if canImport(AmityUIKitLiveStream)
//        let liveStreamBroadcastViewController =
//            LiveStreamBroadcastViewController(client: AmityUIKitManager.client, targetId: targetId, targetType: targetType)
//        liveStreamBroadcastViewController.destinationToUnwindBackAfterFinish = destinationToUnwindBackAfterFinish
//        liveStreamBroadcastViewController.modalPresentationStyle = .fullScreen
//        source.present(liveStreamBroadcastViewController, animated: true, completion: nil)
//        #else
//        print("To broadcast live stream, please install AmityUIKitLiveStream, see also `SampleApp/INSTALLATION.md`")
//        #endif
//
//    }
    
    override func homeCommunityDidScroll(_ scrollView: UIScrollView) {
        debugPrint(scrollView.contentOffset.y)
    }
    
    override func createLiveStreamPost(from source: AmityViewController, targetId: String?, targetType: AmityPostTargetType, openByProfileTrueID: Bool = false, destinationToUnwindBackAfterFinish: UIViewController) {
        
        debugPrint(openByProfileTrueID)
        
                #if canImport(AmityUIKitLiveStream)
                let liveStreamBroadcastViewController =
                    LiveStreamBroadcastViewController(client: AmityUIKitManager.client, targetId: targetId, targetType: targetType)
                liveStreamBroadcastViewController.destinationToUnwindBackAfterFinish = destinationToUnwindBackAfterFinish
                liveStreamBroadcastViewController.modalPresentationStyle = .fullScreen
                source.present(liveStreamBroadcastViewController, animated: true, completion: nil)
                #else
                print("To broadcast live stream, please install AmityUIKitLiveStream, see also `SampleApp/INSTALLATION.md`")
                #endif
    }
    
    override func openLiveStreamPlayer(from source: AmityViewController, postId: String, streamId: String, post: AmityPost) {
        #if canImport(AmityUIKitLiveStream)
        let liveStreamPlayerVC = LiveStreamPlayerViewController(streamIdToWatch: streamId, postId: postId, post: post)
        source.present(liveStreamPlayerVC, animated: true, completion: nil)
        #else
        print("To watch live stream, please install AmityUIKitLiveStream, see also `SampleApp/INSTALLATION.md`")
        #endif
    }
    override func shareCommunityPostDidTap(from source: UIViewController, title: String?, postId: String, communityId: String) {
        debugPrint(postId as Any)
        debugPrint(communityId as Any)
    }
    
    override func shareCommunityProfileDidTap(from source: UIViewController, communityModelExternal: AmityCommunityModelExternal) {
        debugPrint(communityModelExternal.communityId)
    }
    
    override func closeAmityCommunityViewController() {
        debugPrint("Close")
    }
    
    override func communityJoinButtonTracking(screenName: String, communityModel: AmityCommunityModelExternal) {
        debugPrint("Screen name: \(screenName) | Community Model: \(communityModel)")
    }
    
//    override func timelineFeedDidScroll(_ scrollView: UIScrollView) {
//        debugPrint(scrollView as Any)
//    }
//
//    override func galleryDidScroll(_ scrollView: UIScrollView) {
//        debugPrint(scrollView as Any)
//    }
}
