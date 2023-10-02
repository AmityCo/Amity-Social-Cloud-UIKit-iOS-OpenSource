//
//  AmityChannelMembership+Extension.swift
//  AmityUIKit
//
//  Created by min khant on 12/05/2021.
//  Copyright © 2021 Amity. All rights reserved.
//

import Foundation

enum AmityChannelRole: String {
    /// Channel moderator
    case channelModerator = "channel-moderator"
    /// Standart member
    case member
    /// Channel moderator
    @available(*, deprecated, message: "Use channelModerator instead.")
    case moderator
}

extension AmityChannelMembershipModel {
    var channelRoles: [AmityChannelRole] {
        guard let roles = roles as? [String] else {
            return []
        }
        return roles.map { AmityChannelRole(rawValue: $0) ?? .member }
    }
}
