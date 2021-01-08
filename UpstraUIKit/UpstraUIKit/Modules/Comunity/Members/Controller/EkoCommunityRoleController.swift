//
//  EkoCommunityRoleController.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 1/5/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

enum EkoCommunityRole: String {
    case moderator
}

protocol EkoCommunityRoleControllerProtocol {
    func add(role: EkoCommunityRole, userIds: [String], _ completion: @escaping (Error?) -> Void)
    func remove(role: EkoCommunityRole, userIds: [String], _ completion: @escaping (Error?) -> Void)
}

final class EkoCommunityRoleController: EkoCommunityRoleControllerProtocol {
    
    private var moderation: EkoCommunityModeration?
    
    init(communityId: String) {
        moderation = EkoCommunityModeration(client: UpstraUIKitManagerInternal.shared.client, andCommunity: communityId)
    }
}

extension EkoCommunityRoleController{
    func add(role: EkoCommunityRole, userIds: [String], _ completion: @escaping (Error?) -> Void) {
        moderation?.addRole(role.rawValue, userIds: userIds, completion: { (success, error) in
            if let error = error {
                completion(error)
                return
            }
            
            if success {
                completion(nil)
            } else {
                completion(EkoError.unknown)
            }
        })
    }
    
    func remove(role: EkoCommunityRole, userIds: [String], _ completion: @escaping (Error?) -> Void) {
        moderation?.removeRole(role.rawValue, userIds: userIds, completion: { (success, error) in
            if let error = error {
                completion(error)
                return
            }
            
            if success {
                completion(nil)
            } else {
                completion(EkoError.unknown)
            }
        })
    }
}
