//
//  AmityCommunityRoleController.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 1/5/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityCommunityRoleControllerProtocol {
    func add(role: AmityCommunityRole, userIds: [String], completion: ((AmityError?) -> Void)?)
    func remove(role: AmityCommunityRole, userIds: [String], completion: ((AmityError?) -> Void)?)
}

final class AmityCommunityRoleController: AmityCommunityRoleControllerProtocol {
    
    private var moderation: AmityCommunityModeration?
    
    init(communityId: String) {
        moderation = AmityCommunityModeration(client: AmityUIKitManagerInternal.shared.client, andCommunity: communityId)
    }
    
    // Add role permisstion to users
    func add(role: AmityCommunityRole, userIds: [String], completion: ((AmityError?) -> Void)?) {
        moderation?.addRole(role.rawValue, userIds: userIds, completion: { (success, error) in
            if success {
                completion?(nil)
            } else {
                if let error = AmityError(error: error) {
                    completion?(error)
                } else {
                    completion?(AmityError.unknown)
                }
            }
        })
    }
    
    // Remove role permisstion from users
    func remove(role: AmityCommunityRole, userIds: [String], completion: ((AmityError?) -> Void)?) {
        moderation?.removeRole(role.rawValue, userIds: userIds, completion: { (success, error) in
            if success {
                completion?(nil)
            } else {
                completion?(AmityError(error: error) ?? .unknown)
            }  
        })
    }

}
