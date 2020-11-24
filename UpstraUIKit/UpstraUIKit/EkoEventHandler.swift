//
//  EkoEventHandler.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 24/11/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

open class EkoEventHandler {
    
    static var shared = EkoEventHandler()
    
    public init() { }
    
    open func communityDidTap(from source: EkoViewController, communityId: String) {
        let viewController = EkoCommunityProfilePageViewController.make(withCommunityId: communityId)
        source.navigationController?.pushViewController(viewController, animated: true)
    }
    
    open func channelDidTap(from source: EkoViewController, channelId: String) {
        let viewController = EkoMessageListViewController.make(channelId: channelId)
        source.navigationController?.pushViewController(viewController, animated: true)
    }
    
    open func postDidtap(from source: EkoViewController, postId: String) {
        let viewController = EkoPostDetailViewController.make(postId: postId)
        source.navigationController?.pushViewController(viewController, animated: true)
    }

    open func userDidTap(from source: EkoViewController, userId: String) {
        let viewController = EkoUserProfilePageViewController.make(withUserId: userId)
        source.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
