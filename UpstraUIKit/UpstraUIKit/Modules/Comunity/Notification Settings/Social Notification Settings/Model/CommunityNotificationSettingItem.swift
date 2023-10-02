//
//  CommunityNotificationSettingItem.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 31/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import Foundation

struct CommunityNotificationSettingItem {
    let event: CommunityNotificationEventType
    let menu: NotificationSettingMenuType
    
    var identifier: String {
        return "\(event).\(menu.identifier)"
    }
    
    static func settingItem(for identifier: String) -> CommunityNotificationSettingItem? {
        let components = identifier.components(separatedBy: ".")
        guard let prefix = components.first,
              let suffix = components.last,
              let type = CommunityNotificationEventType(rawValue: prefix),
              let value = NotificationSettingMenuType.type(for: suffix) else {
            return nil
        }
        return CommunityNotificationSettingItem(event: type, menu: value)
    }
    
}
