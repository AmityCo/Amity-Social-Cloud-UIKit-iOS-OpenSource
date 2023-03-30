//
//  AmityChannelEventHandler.swift
//  AmityUIKit
//
//  Created by min khant on 09/07/2021.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

/// Share event handler for channel
///
/// Events which are interacted on AmityUIKIt will trigger following functions
/// These all functions having its default behavior
///
open class AmityChannelEventHandler {
    static var shared = AmityChannelEventHandler()
    
    public init() { }
    
    /// Event for channel
    /// It will be triggered when channel list or chat button is tapped
    ///
    /// A default behavior is navigating to `AmityMessageListViewController`
    open func channelDidTap(from source: AmityViewController,
                            channelId: String, subChannelId: String) {
        let settings = AmityMessageListViewController.Settings()
        let viewController = AmityMessageListViewController.make(channelId: channelId, subChannelId: subChannelId, settings: settings)
        source.navigationController?.pushViewController(viewController, animated: true)
    }
    
    /// Event for Leave Chat
    /// It will be triggered when leave chat is success
    ///
    /// A default behavior is pop back to rootViewcontroller
    open func channelDidLeaveSuccess(from source: AmityViewController) {
        source.navigationController?.popToRootViewController(animated: true)
    }
    
    /// Event for Update Group Chat Detail
    /// It will be triggered when group chate update is complete
    ///
    /// A default behavior is pop back to prev view controller
    open func channelGroupChatUpdateDidComplete(from source: AmityViewController) {
        source.navigationController?.popViewController(animated: true)
    }
    
    /// Event for creating chat with users
    /// It will be triggered when user click add button to create chat with users or to add many users
    ///
    /// A default behavior is navigating to `AmityMemberPickerViewController`
    open func channelAddMemberDidTap(from source: AmityViewController,
                              channelId: String,
                              selectedUsers: [AmitySelectMemberModel],
                              completionHandler: @escaping ([AmitySelectMemberModel]) -> ()) {
        let vc = AmityMemberPickerViewController.make(withCurrentUsers: selectedUsers)
        vc.selectUsersHandler = { storeUsers in
            completionHandler(storeUsers)
        }
        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        source.present(navVc, animated: true, completion: nil)
    }
    
    /// Event for creating new chat with users
    /// It will be triggered when user click add button to create chat with users
    ///
    /// A default behavior is navigating to `AmityMemberPickerViewController`
    open func channelCreateNewChat(from source: AmityViewController,
                              completionHandler: @escaping ([AmitySelectMemberModel]) -> ()) {
        let vc = AmityMemberPickerViewController.make()
        vc.selectUsersHandler = { storeUsers in
            completionHandler(storeUsers)
        }
        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        source.present(navVc, animated: true, completion: nil)
    }
    
}
