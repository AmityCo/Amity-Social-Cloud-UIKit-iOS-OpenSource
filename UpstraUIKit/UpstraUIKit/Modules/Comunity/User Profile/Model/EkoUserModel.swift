//
//  EkoUserModel.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 29/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import EkoChat

struct EkoUserModel {
    
    let userId: String
    let displayName: String
    let avatarFileId: String
    let about: String
    
    init(user: EkoUser) {
        userId = user.userId
        displayName = user.displayName ?? EkoLocalizedStringSet.anonymous
        avatarFileId = user.avatarFileId ?? ""
        about = user.userDescription
    }
    
    var isCurrentUser: Bool {
        return userId == UpstraUIKitManagerInternal.shared.client.currentUserId
    }
    
}
