//
//  EkoCommunityMembershipModel.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 15/12/2563 BE.
//  Copyright © 2563 BE Upstra. All rights reserved.
//

import UIKit
import EkoChat

struct EkoCommunityMembershipModel {

    let user: EkoUser?
    let displayName: String
    let userId: String
    let roles: NSArray
    var isCurrentUser: Bool {
        return userId == UpstraUIKitManagerInternal.shared.client.currentUserId
    }
    
    var isModerator: Bool = false
    
    init(member: EkoCommunityMembership) {
        self.user = member.user?.object
        self.displayName = member.displayName == "" ? EkoLocalizedStringSet.anonymous : member.displayName
        self.userId = member.userId
        self.roles = member.roles
    }
    
}
