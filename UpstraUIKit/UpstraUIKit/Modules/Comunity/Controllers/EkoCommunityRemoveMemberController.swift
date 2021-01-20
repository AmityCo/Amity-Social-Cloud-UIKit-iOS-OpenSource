//
//  EkoCommunityRemoveMemberController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 22/12/2563 BE.
//  Copyright © 2563 BE Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoCommunityRemoveMemberControllerProtocol {
    func remove(users: [EkoCommunityMembershipModel],at indexPath: IndexPath, _ completion: @escaping (EkoError?) -> Void)
}

final class EkoCommunityRemoveMemberController: EkoCommunityRemoveMemberControllerProtocol {
    
    private var membershipParticipation: EkoCommunityParticipation?
    
    init(communityId: String) {
        membershipParticipation = EkoCommunityParticipation(client: UpstraUIKitManagerInternal.shared.client, andCommunityId: communityId)
    }
    
    deinit {
        membershipParticipation = nil
    }
    
    func remove(users: [EkoCommunityMembershipModel], at indexPath: IndexPath, _ completion: @escaping (EkoError?) -> Void) {
        let userId = users[indexPath.row].userId
        membershipParticipation?.removeUsers([userId], completion: { (success, error) in
            if success {
                completion(nil)
            } else {
                completion(EkoError(error: error) ?? .unknown)
            }
        })
    }

}
