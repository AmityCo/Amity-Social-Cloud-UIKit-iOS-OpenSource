//
//  EkoCommunityUserModeratorController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 22/12/2563 BE.
//  Copyright © 2563 BE Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoCommunityUserRolesControllerProtocol {
    func getUserRoles(withUserId userId: String, role: EkoCommunityRole) -> Bool
}

final class EkoCommunityUserRolesController: EkoCommunityUserRolesControllerProtocol {
    private var membershipParticipation: EkoCommunityParticipation?
    private var membership: EkoCommunityMembership?
    
    init(communityId: String) {
        membershipParticipation = EkoCommunityParticipation(client: UpstraUIKitManagerInternal.shared.client, andCommunityId: communityId)
    }
    
    func getUserRoles(withUserId userId: String, role: EkoCommunityRole) -> Bool {
        membership = membershipParticipation?.getMembership(UpstraUIKitManagerInternal.shared.currentUserId)
        guard let roles = membership?.roles as? [String] else { return false }
        return roles.contains(role.rawValue)
    }
}
