//
//  EkoCommunityAddMemberController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 22/12/2563 BE.
//  Copyright © 2563 BE Upstra. All rights reserved.
//

import UIKit
import EkoChat
protocol EkoCommunityAddMemberControllerProtocol {
    func add(withUserIds userIds: [String], _ completion: @escaping (EkoError?) -> Void)
}

final class EkoCommunityAddMemberController: EkoCommunityAddMemberControllerProtocol {
    
    private var membershipParticipation: EkoCommunityParticipation?
    private var memberCollection: EkoCollection<EkoCommunityMembership>?
    private var memberToken: EkoNotificationToken?
    
    init(communityId: String) {
        membershipParticipation = EkoCommunityParticipation(client: UpstraUIKitManagerInternal.shared.client, andCommunityId: communityId)
    }
    
    func add(withUserIds userIds: [String], _ completion: @escaping (EkoError?) -> Void) {
        membershipParticipation?.addUsers(userIds, completion: { (success, error) in
            if success {
                completion(nil)
            } else {
                completion(EkoError.unknown)
            }
        })
    }
}
