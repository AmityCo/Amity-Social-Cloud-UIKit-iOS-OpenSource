//
//  CustomEventHandler.swift
//  SampleApp
//
//  Created by Nontapat Siengsanor on 22/3/2564 BE.
//  Copyright © 2564 BE Eko. All rights reserved.
//

import UIKit
import UpstraUIKit

class CustomEventHandler: EkoEventHandler {
    
    override func userDidTap(from source: EkoViewController, userId: String) {

        let settings = EkoUserProfilePageSettings()
        settings.shouldChatButtonHide = true
        
        let viewController = EkoUserProfilePageViewController.make(withUserId: userId, settings: settings)
        source.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func communityDidTap(from source: EkoViewController, communityId: String) {
        
        let settings = EkoCommunityProfilePageSettings()
        settings.shouldChatButtonHide = true
        
        let viewController = EkoCommunityProfilePageViewController.make(withCommunityId: communityId, settings: settings)
        source.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func communityChannelDidTap(from source: EkoViewController, channelId: String) {
        print("Channel id: \(channelId)")
    }
    
    override func createPostDidTap(from source: EkoViewController, postTarget: EkoPostTarget) {
        
        let settings = EkoPostEditorSettings()
        settings.shouldFileButtonHide = false
        
        if source is EkoPostTargetSelectionViewController {
            let viewController = EkoPostCreateViewController.make(postTarget: postTarget, settings: settings)
            source.navigationController?.pushViewController(viewController, animated: true)
        } else {
            let viewController = EkoPostCreateViewController.make(postTarget: postTarget, settings: settings)
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .overFullScreen
            source.present(navigationController, animated: true, completion: nil)
        }
    }
}
