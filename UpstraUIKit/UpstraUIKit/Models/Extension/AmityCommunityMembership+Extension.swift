//
//  AmityCommunityMembership+Extension.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 25/1/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import AmitySDK

enum AmityCommunityRole: String {
    /// Community moderator
    case communityModerator = "community-moderator"
    /// Standart member
    case member
    /// Community moderator.
    @available(*, deprecated, message: "Use communityModerator instead.")
    case moderator
}

extension AmityCommunityMember {
    
    var communityRoles: [AmityCommunityRole] {
        guard let roles = roles as? [String] else {
            return []
        }
        return roles.map { AmityCommunityRole(rawValue: $0) ?? .member }
    }

    var hasModeratorRole: Bool {
        return communityRoles.contains { $0 == .moderator || $0 == .communityModerator }
    }
}
