//
//  AmityUserModel.swift
//  AmityUIKitLiveStream
//
//  Created by Mono TheForestcat on 26/9/2565 BE.
//

import AmitySDK
import AmityUIKit

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
        return userId == AmityUIKitManager.currentUserId
    }
    
}
