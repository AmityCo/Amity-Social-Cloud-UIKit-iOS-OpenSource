//
//  AmityUserSettingsCreateMenuViewModel.swift
//  AmityUIKit
//
//  Created by Hamlet on 28.05.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import Foundation

protocol AmityUserSettingsCreateMenuViewModelProtocol {
    func createSettingsItems(shouldNotificationItemShow: Bool, isNotificationEnabled: Bool, isOwner: Bool, isReported: Bool, isFollowing: Bool, _ completion: (([AmitySettingsItem]) -> Void)?)
}

final class AmityUserSettingsCreateMenuViewModel: AmityUserSettingsCreateMenuViewModelProtocol {
    func createSettingsItems(shouldNotificationItemShow: Bool, isNotificationEnabled: Bool, isOwner: Bool, isReported: Bool, isFollowing: Bool, _ completion: (([AmitySettingsItem]) -> Void)?) {

        var settingsItems = [AmitySettingsItem]()
        if isOwner {
            // MARK: Basic info item
            let manageItemHeader = AmitySettingsItem.HeaderContent(title: AmityUserSettingsItem.basicInfo.title)
            
            settingsItems.append(.header(content: manageItemHeader))
            
            let editProfile = AmityUserSettingsItem.editProfile
            let editProfileItem = AmitySettingsItem.NavigationContent(identifier: editProfile.identifier, icon: editProfile.icon, title: editProfile.title, description: nil)
            
            settingsItems.append(.navigationContent(content: editProfileItem))
            
            settingsItems.append(.separator)
            
            completion?(settingsItems)
            return
        }
        
        // MARK: Create Manage item
        let manageItemHeader = AmitySettingsItem.HeaderContent(title: AmityUserSettingsItem.manage.title)
        
        settingsItems.append(.header(content: manageItemHeader))
        
        if isFollowing {
            let unfollow = AmityUserSettingsItem.unfollow
            let unfollowItem = AmitySettingsItem.TextContent(identifier: unfollow.identifier, icon: unfollow.icon, title: unfollow.title, description: nil)
            settingsItems.append(.textContent(content: unfollowItem))
        }
        
        let report = isReported ? AmityUserSettingsItem.unreport : AmityUserSettingsItem.report
        let reportItem = AmitySettingsItem.TextContent(identifier: report.identifier, icon: report.icon, title: report.title, description: nil)
        settingsItems.append(.textContent(content: reportItem))
        
        settingsItems.append(.separator)
        completion?(settingsItems)
    }
}
