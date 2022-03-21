//
//  AmityUserModel.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 29/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import AmitySDK

struct AmityUserModel {
    
    let userId: String
    let displayName: String
    let avatarURL: String
    let avatarCustomURL: String
    let about: String
    let isGlobalBan: Bool
    
    init(user: AmityUser) {
        userId = user.userId
        displayName = user.displayName ?? AmityLocalizedStringSet.General.anonymous.localizedString
        avatarURL = user.getAvatarInfo()?.fileURL ?? ""
        avatarCustomURL = user.avatarCustomUrl ?? ""
        about = user.userDescription
        isGlobalBan = user.isGlobalBan
    }
    
    var isCurrentUser: Bool {
        return userId == AmityUIKitManagerInternal.shared.client.currentUserId
    }
    
}
