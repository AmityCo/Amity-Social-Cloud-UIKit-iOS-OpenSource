//
//  NotificationSettingsType.swift
//  UpstraUIKit
//
//  Created by Hamlet on 16.03.21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import EkoChat

enum CommunityNotificationEventType: String {
    case postReacted
    case postCreated
    case commentReacted
    case commentCreated
    case commentReplied
    
    init?(eventType: EkoCommunityNotificationEventType) {
        switch eventType {
        case .postCreated: self = .postCreated
        case .postReacted: self = .postReacted
        case .commentReacted: self = .commentReacted
        case .commentReplied: self = .commentReplied
        case .commentCreated: self = .commentCreated
        @unknown default:
            return nil
        }
    }
    
    var eventType: EkoCommunityNotificationEventType {
        switch self {
        case .postCreated: return .postCreated
        case .postReacted: return .postReacted
        case .commentReacted: return .commentReacted
        case .commentReplied: return .commentReplied
        case .commentCreated: return .commentCreated
        }
    }
    
    var title: String {
        switch self {
        case .postCreated: return EkoLocalizedStringSet.CommunityNotificationSettings.titleNewPosts.localizedString
        case .postReacted: return EkoLocalizedStringSet.CommunityNotificationSettings.titleReactsPosts.localizedString
        case .commentReacted: return EkoLocalizedStringSet.CommunityNotificationSettings.titleReactsComments.localizedString
        case .commentReplied: return EkoLocalizedStringSet.CommunityNotificationSettings.titleReplies.localizedString
        case .commentCreated: return EkoLocalizedStringSet.CommunityNotificationSettings.titleNewComments.localizedString
        }
    }
    
    var description: String {
        switch self {
        case .postCreated: return EkoLocalizedStringSet.CommunityNotificationSettings.descriptionNewPosts.localizedString
        case .postReacted: return EkoLocalizedStringSet.CommunityNotificationSettings.descriptionReactsPosts.localizedString
        case .commentReacted: return EkoLocalizedStringSet.CommunityNotificationSettings.descriptionReactsComments.localizedString
        case .commentReplied: return EkoLocalizedStringSet.CommunityNotificationSettings.descriptionReplies.localizedString
        case .commentCreated: return EkoLocalizedStringSet.CommunityNotificationSettings.descriptionNewComments.localizedString
        }
    }
    
}
