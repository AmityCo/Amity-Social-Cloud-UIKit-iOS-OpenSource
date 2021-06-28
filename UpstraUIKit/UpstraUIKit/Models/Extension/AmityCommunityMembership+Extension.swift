//
//  AmityCommunityMembership+Extension.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 25/1/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import AmitySDK

enum AmityCommunityRole: String {
    case moderator
    case member
}

extension AmityCommunityMember {
    
    var communityRoles: [AmityCommunityRole] {
        guard let roles = roles as? [String] else {
            return []
        }
        return roles.map { AmityCommunityRole(rawValue: $0) ?? .member }
    }
    
}
