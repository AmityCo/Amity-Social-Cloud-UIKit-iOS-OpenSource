//
//  EkoCommunitySettingsModel.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 16/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

struct EkoCommunitySettingsModel {
    enum SettingsType {
        case editProfile
        case member
        case leave
        case close
    }

    let title: String
    let icon: UIImage?
    let isLast: Bool
    let type: SettingsType
    
    init(title: String, icon: UIImage?, isLast: Bool = false, type: SettingsType) {
        self.title = title
        self.icon = icon
        self.isLast = isLast
        self.type = type
    }
    
    static func prepareData(isCreator: Bool) -> [Self] {
        // isCreator or isModerator
        if isCreator {
            return [
                EkoCommunitySettingsModel(title: EkoLocalizedStringSet.communitySettingsEditProfile.localizedString, icon: EkoIconSet.iconEdit, type: .editProfile),
                EkoCommunitySettingsModel(title: EkoLocalizedStringSet.communitySettingsMembers.localizedString, icon: EkoIconSet.iconMember, type: .member),
                EkoCommunitySettingsModel(title: EkoLocalizedStringSet.communitySettingsCloseCommunity.localizedString, icon: nil, isLast: true, type: .close)
            ]
        } else {
            return [
                EkoCommunitySettingsModel(title: EkoLocalizedStringSet.communitySettingsMembers.localizedString, icon: EkoIconSet.iconMember, type: .member),
                EkoCommunitySettingsModel(title: EkoLocalizedStringSet.communitySettingsLeaveCommunity.localizedString, icon: nil, isLast: true, type: .leave)
            ]
        }
    }
    
}
