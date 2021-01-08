//
//  EkoCommunityRemoveMemberController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 22/12/2563 BE.
//  Copyright © 2563 BE Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoCommunityRemoveMemberController {
    
    private var membershipParticipation: EkoCommunityParticipation?
    private var memberCollection: EkoCollection<EkoCommunityMembership>?
    private var memberToken: EkoNotificationToken?
    
    init(communityId: String) {
        membershipParticipation = EkoCommunityParticipation(client: UpstraUIKitManagerInternal.shared.client, andCommunityId: communityId)
    }
    
    func remove(userIds: [String], completion: @escaping () -> Void) {
        membershipParticipation?.removeUsers(userIds, completion: { (status, error) in
            guard status, error == nil else { return }
            completion()
        })
    }
}
