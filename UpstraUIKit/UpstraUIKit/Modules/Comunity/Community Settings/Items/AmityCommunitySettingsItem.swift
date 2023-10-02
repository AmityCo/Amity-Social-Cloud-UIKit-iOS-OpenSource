//
//  AmityCommunitySettingsItem.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 11/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

enum AmityCommunitySettingsItem: String {
    case basicInfo
    case editProfile
    case members
    case notification
    case communityPermissionHeader
    case postReview
    case leaveCommunity
    case closeCommunity
    
    var identifier: String {
        return self.rawValue
    }
    
    var title: String {
        switch self {
        case .basicInfo:
            return AmityLocalizedStringSet.CommunitySettings.itemHeaderBasicInfo.localizedString
        case .editProfile:
            return AmityLocalizedStringSet.CommunitySettings.itemTitleEditProfile.localizedString
        case .members:
            return AmityLocalizedStringSet.CommunitySettings.itemTitleMembers.localizedString
        case .notification:
            return AmityLocalizedStringSet.CommunitySettings.itemTitleNotifications.localizedString
        case .communityPermissionHeader:
            return AmityLocalizedStringSet.CommunitySettings.itemHeaderCommunityPermissions.localizedString
        case .postReview:
            return AmityLocalizedStringSet.CommunitySettings.itemTitlePostReview.localizedString
        case .leaveCommunity:
            return AmityLocalizedStringSet.CommunitySettings.itemTitleLeaveCommunity.localizedString
        case .closeCommunity:
            return AmityLocalizedStringSet.CommunitySettings.itemTitleCloseCommunity.localizedString
        }
    }
    
    var description: String? {
        switch self {
        case .closeCommunity:
            return AmityLocalizedStringSet.CommunitySettings.itemDescCloseCommunity.localizedString
        default:
            return nil
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .editProfile:
            return AmityIconSet.CommunitySettings.iconItemEditProfile
        case .members:
            return AmityIconSet.CommunitySettings.iconItemMembers
        case .notification:
            return AmityIconSet.CommunitySettings.iconItemNotification
        case .postReview:
            return AmityIconSet.CommunitySettings.iconItemPostReview
        default:
            return nil
        }
    }
}
