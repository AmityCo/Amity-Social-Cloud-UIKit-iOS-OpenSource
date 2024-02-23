//
//  AmityUserSettingsCreateMenuViewModel.swift
//  AmityUIKit
//
//  Created by Hamlet on 28.05.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import Foundation
import AmitySDK

struct UserSettingsConfiguration {
    let isOwner: Bool
    let isReported: Bool
    let isFollowing: Bool
    let isBlocked: Bool
}

protocol AmityUserSettingsCreateMenuViewModelProtocol {
    func createSettingItems(config: UserSettingsConfiguration) -> [AmitySettingsItem]
}

final class AmityUserSettingsCreateMenuViewModel: AmityUserSettingsCreateMenuViewModelProtocol {
    
    func createSettingItems(config: UserSettingsConfiguration) -> [AmitySettingsItem] {
        
        var items = [AmitySettingsItem]()
        
        if config.isOwner {
            // MARK: Basic info item
            let manageItemHeader = AmitySettingsItem.HeaderContent(title: AmityUserSettingsItem.basicInfo.title)
            items.append(.header(content: manageItemHeader))
            
            let editProfile = AmityUserSettingsItem.editProfile
            let editProfileItem = AmitySettingsItem.NavigationContent(identifier: editProfile.identifier, icon: editProfile.icon, title: editProfile.title, description: nil)
            
            items.append(.navigationContent(content: editProfileItem))
            items.append(.separator)
            
            return items
        }
        
        // MARK: Create Manage item
        let manageItemHeader = AmitySettingsItem.HeaderContent(title: AmityUserSettingsItem.manage.title)
        
        items.append(.header(content: manageItemHeader))
        
        if config.isFollowing {
            let unfollow = AmityUserSettingsItem.unfollow
            let unfollowItem = AmitySettingsItem.TextContent(identifier: unfollow.identifier, icon: unfollow.icon, title: unfollow.title, description: nil)
            items.append(.textContent(content: unfollowItem))
        }
        
        let report = config.isReported ? AmityUserSettingsItem.unreport : AmityUserSettingsItem.report
        let reportItem = AmitySettingsItem.TextContent(identifier: report.identifier, icon: report.icon, title: report.title, description: nil)
        items.append(.textContent(content: reportItem))
        items.append(.separator)
        
        let blockUnblock = config.isBlocked ? AmityUserSettingsItem.unblockUser : AmityUserSettingsItem.blockUser
        let blockItem = AmitySettingsItem.TextContent(identifier: blockUnblock.identifier, icon: blockUnblock.icon, title: blockUnblock.title, description: nil)
        items.append(.textContent(content: blockItem))
        items.append(.separator)
        return items
    }
}
