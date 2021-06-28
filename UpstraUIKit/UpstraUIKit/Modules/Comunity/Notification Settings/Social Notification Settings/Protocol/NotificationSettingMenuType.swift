//
//  NotificationSettingMenuType.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 31/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import Foundation

enum NotificationSettingOptionType: String {
    case everyOne
    case onlyModerator
    case off
}

enum NotificationSettingMenuType {
    case description
    case separator
    case option(NotificationSettingOptionType)
    
    private static let descriptionIdentifier = "description"
    private static let separatorIdentifier = "separator"
    
    var identifier: String {
        switch self {
        case .description:
            return NotificationSettingMenuType.descriptionIdentifier
        case .separator:
            return NotificationSettingMenuType.separatorIdentifier
        case .option(let option):
            return option.rawValue
        }
    }
    
    static func type(for identifier: String) -> NotificationSettingMenuType? {
        if identifier == NotificationSettingMenuType.descriptionIdentifier {
            return .description
        } else if identifier == NotificationSettingMenuType.separatorIdentifier {
            return .separator
        } else if let option = NotificationSettingOptionType(rawValue: identifier) {
            return .option(option)
        }
        return nil
    }
    
}
