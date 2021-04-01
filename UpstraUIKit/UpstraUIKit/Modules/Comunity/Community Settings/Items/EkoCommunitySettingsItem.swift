//
//  EkoCommunitySettingsItem.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 11/3/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import UIKit

enum EkoCommunitySettingsItem: String {
    case basicInfo
    case editProfile
    case members
    case notification
    case postReview
    case leaveCommunity
    case closeCommunity
    
    var identifier: String {
        return self.rawValue
    }
    
    var title: String {
        switch self {
        case .basicInfo:
            return EkoLocalizedStringSet.CommunitySettings.itemHeaderBasicInfo.localizedString
        case .editProfile:
            return EkoLocalizedStringSet.CommunitySettings.itemTitleEditProfile.localizedString
        case .members:
            return EkoLocalizedStringSet.CommunitySettings.itemTitleMembers.localizedString
        case .notification:
            return EkoLocalizedStringSet.CommunitySettings.itemTitleNotifications.localizedString
        case .postReview:
            return EkoLocalizedStringSet.CommunitySettings.itemTitlePostReview.localizedString
        case .leaveCommunity:
            return EkoLocalizedStringSet.CommunitySettings.itemTitleLeaveCommunity.localizedString
        case .closeCommunity:
            return EkoLocalizedStringSet.CommunitySettings.itemTitleCloseCommunity.localizedString
        }
    }
    
    var description: String? {
        switch self {
        case .closeCommunity:
            return EkoLocalizedStringSet.CommunitySettings.itemDescCloseCommunity.localizedString
        default:
            return nil
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .editProfile:
            return EkoIconSet.CommunitySettings.iconItemEditProfile
        case .members:
            return EkoIconSet.CommunitySettings.iconItemMembers
        case .notification:
            return EkoIconSet.CommunitySettings.iconItemNotification
        case .postReview:
            return EkoIconSet.CommunitySettings.iconItemPostReview
        default:
            return nil
        }
    }
}
