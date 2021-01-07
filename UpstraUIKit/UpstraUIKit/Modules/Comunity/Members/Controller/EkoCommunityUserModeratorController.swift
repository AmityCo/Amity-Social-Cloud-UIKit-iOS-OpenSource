//
//  EkoCommunityUserModeratorController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 22/12/2563 BE.
//  Copyright © 2563 BE Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoCommunityUserModeratorController {
    private var membershipParticipation: EkoCommunityParticipation?
    private var membership: EkoCommunityMembership? 
    private var userId: String
    
    var isModerator: Bool {
        return getUserIsModerator()
    }
    
    init(communityId: String, userId: String) {
        membershipParticipation = EkoCommunityParticipation(client: UpstraUIKitManagerInternal.shared.client, andCommunityId: communityId)
        self.userId = userId
    }
    
    private func getUserIsModerator() -> Bool {
        membership = membershipParticipation?.getMembership(userId)
        guard let roles = membership?.roles as? [String] else { return false }
        return roles.contains("moderator")
    }
}
