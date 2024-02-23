//
//  AmityUserSettingsItem.swift
//  AmityUIKit
//
//  Created by Hamlet on 28.05.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

enum AmityUserSettingsItem: String {
    case manage
    case unfollow
    case report
    case unreport
    case basicInfo
    case editProfile
    case blockUser
    case unblockUser
    
    var identifier: String {
        return self.rawValue
    }
    
    var title: String {
        switch self {
        case .manage:
            return AmityLocalizedStringSet.UserSettings.itemHeaderManageInfo.localizedString
        case .unfollow:
            return AmityLocalizedStringSet.UserSettings.itemUnfollow.localizedString
        case .report:
            return AmityLocalizedStringSet.UserSettings.itemReportUser.localizedString
        case .unreport:
            return AmityLocalizedStringSet.UserSettings.itemUnreportUser.localizedString
        case .basicInfo:
            return AmityLocalizedStringSet.UserSettings.itemHeaderBasicInfo.localizedString
        case .editProfile:
            return AmityLocalizedStringSet.UserSettings.itemEditProfile.localizedString
        case .blockUser:
            return AmityLocalizedStringSet.UserSettings.itemBlockUser.localizedString
        case .unblockUser:
            return AmityLocalizedStringSet.UserSettings.itemUnblockUser.localizedString
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .unfollow:
            return AmityIconSet.UserSettings.iconItemUnfollowUser
        case .report, .unreport:
            return AmityIconSet.UserSettings.iconItemReportUser
        case .editProfile:
            return AmityIconSet.UserSettings.iconItemEditProfile
        case .blockUser, .unblockUser:
            return AmityIconSet.UserSettings.iconItemBlockUser
        case .basicInfo, .manage:
            return nil
        }
    }
}
