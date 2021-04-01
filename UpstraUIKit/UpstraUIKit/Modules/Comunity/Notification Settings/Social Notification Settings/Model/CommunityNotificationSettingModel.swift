//
//  NewPostNotificationSettingModel.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 24/3/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import EkoChat

struct CommunityNotificationSettingModel: Equatable {
    
    let isNetworkEnabled: Bool
    var selectedOption: NotificationSettingOptionType
    
    init(event: EkoCommunityNotificationEvent, isUserListeningFromModerator: Bool) {
        isNetworkEnabled = event.isNetworkEnabled
        
        // set current selected option
        if event.isEnabled, let filterType = event.roleFilter?.filterType {
            switch filterType {
            case .only:
                let roles = event.roleFilter?.roleIds?.compactMap { EkoCommunityRole(rawValue: $0) } ?? []
                selectedOption = roles.contains(.moderator) ? .onlyModerator : .everyOne
            case .all:
                // if user level setting is listening to moderator actions,
                // an `everyone` option will be hidden and default changes.
                selectedOption = isUserListeningFromModerator ? .onlyModerator : .everyOne
            default:
                selectedOption = .everyOne
            }
        } else {
            selectedOption = .off
        }
    }
    
}
