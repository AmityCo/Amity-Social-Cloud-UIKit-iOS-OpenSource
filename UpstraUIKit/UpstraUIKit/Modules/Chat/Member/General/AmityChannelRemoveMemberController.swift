//
//  AmityChannelRemoveMemberController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 22/12/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityChannelRemoveMemberControllerProtocol {
    func remove(users: [AmityChannelMembershipModel], at indexPath: IndexPath, _ completion: @escaping (AmityError?) -> Void)
}

final class AmityChannelRemoveMemberController: AmityChannelRemoveMemberControllerProtocol {
    
    private var membershipParticipation: AmityChannelParticipation?
    
    init(channelId: String) {
        membershipParticipation = AmityChannelParticipation(client: AmityUIKitManagerInternal.shared.client, andChannel: channelId)
    }
    
    func remove(users: [AmityChannelMembershipModel], at indexPath: IndexPath, _ completion: @escaping (AmityError?) -> Void) {
        let userId = users[indexPath.row].userId
        membershipParticipation?.removeMembers([userId], completion: { (success, error) in
            if success {
                completion(nil)
            } else {
                completion(AmityError(error: error) ?? .unknown)
            }
        })
    }

}
