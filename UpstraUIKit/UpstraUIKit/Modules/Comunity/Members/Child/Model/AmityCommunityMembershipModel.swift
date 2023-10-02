//
//  AmityCommunityMembershipModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 15/12/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

struct AmityCommunityMembershipModel {

    let user: AmityUser?
    let displayName: String
    let userId: String
    let roles: [String]
    let isGlobalBan: Bool
    var isCurrentUser: Bool {
        return userId == AmityUIKitManagerInternal.shared.client.currentUserId
    }
    let avatarURL: String
    
    let isModerator: Bool
    
    init(member: AmityCommunityMember) {
        self.user = member.user
        self.displayName = member.displayName == "" ? AmityLocalizedStringSet.General.anonymous.localizedString : member.displayName
        self.userId = member.userId
        self.roles = member.roles
        self.avatarURL = member.user?.getAvatarInfo()?.fileURL ?? ""
        self.isModerator = roles.contains { $0 == AmityCommunityRole.moderator.rawValue || $0 == AmityCommunityRole.communityModerator.rawValue }
        self.isGlobalBan = member.user?.isGlobalBanned ?? false
    }
}
