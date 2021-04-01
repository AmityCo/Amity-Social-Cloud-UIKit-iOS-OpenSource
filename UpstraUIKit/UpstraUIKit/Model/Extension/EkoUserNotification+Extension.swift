//
//  EkoUserNotification+Extension.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 31/3/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import EkoChat

extension EkoUserNotification {
    
    // A flag for checking if user level notification is receiving to moderator role specifically.
    // If true, common user actions happened in community will not be notified to the current user.
    var isSocialListeningToModerator: Bool {
        guard  let socialModule = modules.first(where: { $0.moduleType == .social }),
               let roleFilter = socialModule.roleFilter else {
            return false
        }
        let roles = roleFilter.roleIds?.compactMap { EkoCommunityRole(rawValue: $0) } ?? []
        return roles.contains(.moderator)
    }
    
}
