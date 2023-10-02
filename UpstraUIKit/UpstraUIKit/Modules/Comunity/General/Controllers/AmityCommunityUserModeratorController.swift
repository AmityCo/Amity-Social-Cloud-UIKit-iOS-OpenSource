//
//  AmityCommunityUserModeratorController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 22/12/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityCommunityUserRolesControllerProtocol {
    func getUserRoles(withUserId userId: String, role: AmityCommunityRole) -> Bool
}

final class AmityCommunityUserRolesController: AmityCommunityUserRolesControllerProtocol {
    private var membershipParticipation: AmityCommunityParticipation?
    private var membership: AmityCommunityMember?
    
    init(communityId: String) {
        membershipParticipation = AmityCommunityParticipation(client: AmityUIKitManagerInternal.shared.client, andCommunityId: communityId)
    }
    
    func getUserRoles(withUserId userId: String, role: AmityCommunityRole) -> Bool {
        membership = membershipParticipation?.getMember(withId: AmityUIKitManagerInternal.shared.currentUserId)
        guard let roles = membership?.roles as? [String] else { return false }
        return roles.contains(role.rawValue)
    }
}
