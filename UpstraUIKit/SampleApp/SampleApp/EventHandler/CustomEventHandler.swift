//
//  CustomEventHandler.swift
//  SampleApp
//
//  Created by Nontapat Siengsanor on 22/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit
import AmityUIKit

class CustomEventHandler: AmityEventHandler {
    
    override func userDidTap(from source: AmityViewController, userId: String) {

        let settings = AmityUserProfilePageSettings()
        settings.shouldChatButtonHide = true
        
        let viewController = AmityUserProfilePageViewController.make(withUserId: userId, settings: settings)
        source.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func communityDidTap(from source: AmityViewController, communityId: String) {
        
        let settings = AmityCommunityProfilePageSettings()
        settings.shouldChatButtonHide = true
        
        let viewController = AmityCommunityProfilePageViewController.make(withCommunityId: communityId, settings: settings)
        source.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func communityChannelDidTap(from source: AmityViewController, channelId: String) {
        print("Channel id: \(channelId)")
    }
    
    override func createPostDidTap(from source: AmityViewController, postTarget: AmityPostTarget) {
        
        let settings = AmityPostEditorSettings()
        settings.shouldFileButtonHide = true
        
        if source is AmityPostTargetPickerViewController {
            let viewController = AmityPostCreatorViewController.make(postTarget: postTarget, settings: settings)
            source.navigationController?.pushViewController(viewController, animated: true)
        } else {
            let viewController = AmityPostCreatorViewController.make(postTarget: postTarget, settings: settings)
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .overFullScreen
            source.present(navigationController, animated: true, completion: nil)
        }
    }
}
