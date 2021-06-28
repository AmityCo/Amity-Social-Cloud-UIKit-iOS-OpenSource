//
//  NotificationSettingsType.swift
//  AmityUIKit
//
//  Created by Hamlet on 16.03.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import AmitySDK

enum CommunityNotificationEventType: String {
    case postReacted
    case postCreated
    case commentReacted
    case commentCreated
    case commentReplied
    
    init?(eventType: AmityCommunityNotificationEventType) {
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
    
    var eventType: AmityCommunityNotificationEventType {
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
        case .postCreated: return AmityLocalizedStringSet.CommunityNotificationSettings.titleNewPosts.localizedString
        case .postReacted: return AmityLocalizedStringSet.CommunityNotificationSettings.titleReactsPosts.localizedString
        case .commentReacted: return AmityLocalizedStringSet.CommunityNotificationSettings.titleReactsComments.localizedString
        case .commentReplied: return AmityLocalizedStringSet.CommunityNotificationSettings.titleReplies.localizedString
        case .commentCreated: return AmityLocalizedStringSet.CommunityNotificationSettings.titleNewComments.localizedString
        }
    }
    
    var description: String {
        switch self {
        case .postCreated: return AmityLocalizedStringSet.CommunityNotificationSettings.descriptionNewPosts.localizedString
        case .postReacted: return AmityLocalizedStringSet.CommunityNotificationSettings.descriptionReactsPosts.localizedString
        case .commentReacted: return AmityLocalizedStringSet.CommunityNotificationSettings.descriptionReactsComments.localizedString
        case .commentReplied: return AmityLocalizedStringSet.CommunityNotificationSettings.descriptionReplies.localizedString
        case .commentCreated: return AmityLocalizedStringSet.CommunityNotificationSettings.descriptionNewComments.localizedString
        }
    }
    
}
