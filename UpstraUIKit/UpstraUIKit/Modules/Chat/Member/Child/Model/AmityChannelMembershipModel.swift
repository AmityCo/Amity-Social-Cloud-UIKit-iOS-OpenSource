//
//  AmityChannelMembershipModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 15/12/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

struct AmityChannelMembershipModel {

    let user: AmityUser?
    let displayName: String
    let userId: String
    let roles: [String]
    var isCurrentUser: Bool {
        return userId == AmityUIKitManagerInternal.shared.client.currentUserId
    }
    let avatarURL: String
    
    let isModerator: Bool
    
    init(member: AmityChannelMember) {
        self.user = member.user
        if let user = user {
            self.displayName = user.displayName ?? AmityLocalizedStringSet.General.anonymous.localizedString
        } else {
            self.displayName = AmityLocalizedStringSet.General.anonymous.localizedString
        }
        self.userId = member.userId
        self.roles = member.roles
        self.avatarURL = member.user?.getAvatarInfo()?.fileURL ?? ""
        
        self.isModerator = roles.contains { $0 == AmityChannelRole.moderator.rawValue || $0 == AmityChannelRole.channelModerator.rawValue }
    }
}
