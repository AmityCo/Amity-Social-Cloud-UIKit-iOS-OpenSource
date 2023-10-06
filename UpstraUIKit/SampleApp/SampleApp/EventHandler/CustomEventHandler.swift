//
//  CustomEventHandler.swift
//  SampleApp
//
//  Created by Nontapat Siengsanor on 22/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit
import AVKit
import AmityUIKit
import AmitySDK
#if canImport(AmityUIKitLiveStream)
import AmityUIKitLiveStream
#endif

#if canImport(AmityVideoPlayerKit)
import AmityVideoPlayerKit
#endif

class CustomEventHandler: AmityEventHandler {
    
    override func userDidTap(from source: AmityViewController, userId: String) {

        let settings = AmityUserProfilePageSettings()
        settings.shouldChatButtonHide = false
        
        let viewController = AmityUserProfilePageViewController.make(withUserId: userId, settings: settings)
        source.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func communityDidTap(from source: AmityViewController, communityId: String) {
        let viewController = AmityCommunityProfilePageViewController.make(withCommunityId: communityId)
        source.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func communityChannelDidTap(from source: AmityViewController, channelId: String, subChannelId: String) {
        var settings = AmityMessageListViewController.Settings()
        settings.shouldShowChatSettingBarButton = true
        let viewController = AmityMessageListViewController.make(channelId: channelId, subChannelId: subChannelId, settings: settings)
        source.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func createPostDidTap(from source: AmityViewController, postTarget: AmityPostTarget, postContentType: AmityPostContentType = .post) {
        var viewController: AmityViewController
        switch postContentType {
        case .post:
            let settings = AmityPostEditorSettings()
            viewController = AmityPostCreatorViewController.make(postTarget: postTarget, settings: settings)
        case .poll:
            viewController = AmityPollCreatorViewController.make(postTarget: postTarget)
        @unknown default:
            super.createPostDidTap(from: source, postTarget: postTarget, postContentType: postContentType)
            return
        }
        
        if source.isModalPresentation {
            source.navigationController?.pushViewController(viewController, animated: true)
        } else {
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .overFullScreen
            source.present(navigationController, animated: true, completion: nil)
        }
    }
    
    override func createLiveStreamPost(
        from source: AmityViewController,
        targetId: String?,
        targetType: AmityPostTargetType,
        destinationToUnwindBackAfterFinish: UIViewController
    ) {
        
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
    
    override func openLiveStreamPlayer(from source: AmityViewController, postId: String, streamId: String) {
        #if canImport(AmityUIKitLiveStream)
        let liveStreamPlayerVC = LiveStreamPlayerViewController(streamIdToWatch: streamId)
        source.present(liveStreamPlayerVC, animated: true, completion: nil)
        #else
        print("To watch live stream, please install AmityUIKitLiveStream, see also `SampleApp/INSTALLATION.md`")
        #endif
    }
    
    override func openRecordedLiveStreamPlayer(from source: AmityViewController, postId: String, stream: AmityStream) {
        #if canImport(AmityVideoPlayerKit)
        let player = AmityRecordedStreamPlayer(client: AmityUIKitManager.client, stream: stream)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        source.present(playerViewController, animated: true) { [weak player] in
            player?.play()
        }
        #else
        print("To watch recorded live stream, please install AmityVideoPlayerKit.")
        #endif
    }
}
