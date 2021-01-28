//
//  EkoCommunityMembership+Extension.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 25/1/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import EkoChat

enum EkoCommunityRole: String {
    case moderator
    case member
    case unknown
}

extension EkoCommunityMembership {
    
    var communityRoles: [EkoCommunityRole] {
        guard let roles = roles as? [String] else {
            return []
        }
        return roles.map { EkoCommunityRole(rawValue: $0) ?? .unknown }
    }
    
}
