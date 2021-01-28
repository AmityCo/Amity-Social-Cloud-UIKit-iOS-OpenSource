//
//  EkoCommunityRoleController.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 1/5/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoCommunityRoleControllerProtocol {
    func add(role: EkoCommunityRole, userIds: [String], completion: ((EkoError?) -> Void)?)
    func remove(role: EkoCommunityRole, userIds: [String], completion: ((EkoError?) -> Void)?)
}

final class EkoCommunityRoleController: EkoCommunityRoleControllerProtocol {
    
    private var moderation: EkoCommunityModeration?
    
    init(communityId: String) {
        moderation = EkoCommunityModeration(client: UpstraUIKitManagerInternal.shared.client, andCommunity: communityId)
    }
    
    // Add role permisstion to users
    func add(role: EkoCommunityRole, userIds: [String], completion: ((EkoError?) -> Void)?) {
        moderation?.addRole(role.rawValue, userIds: userIds, completion: { (success, error) in
            if success {
                completion?(nil)
            } else {
                if let error = EkoError(error: error) {
                    completion?(error)
                } else {
                    completion?(EkoError.unknown)
                }
            }
        })
    }
    
    // Remove role permisstion from users
    func remove(role: EkoCommunityRole, userIds: [String], completion: ((EkoError?) -> Void)?) {
        moderation?.removeRole(role.rawValue, userIds: userIds, completion: { (success, error) in
            if success {
                completion?(nil)
            } else {
                completion?(EkoError(error: error) ?? .unknown)
            }  
        })
    }

}
