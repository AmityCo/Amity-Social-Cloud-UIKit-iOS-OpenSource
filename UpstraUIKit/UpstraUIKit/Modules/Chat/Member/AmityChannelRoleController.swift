//
//  AmityChannelRoleController.swift
//  AmityUIKit
//
//  Created by min khant on 12/05/2021.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityChannelRoleControllerProtocol {
    func add(role: AmityChannelRole, userIds: [String], completion: ((AmityError?) -> Void)?)
    func remove(role: AmityChannelRole, userIds: [String], completion: ((AmityError?) -> Void)?)
}

final class AmityChannelRoleController: AmityChannelRoleControllerProtocol {
    
    private var moderation: AmityChannelModeration?
    
    init(channelId: String) {
        moderation = AmityChannelModeration(client: AmityUIKitManagerInternal.shared.client, andChannel: channelId)
    }
    
    // Add role permisstion to users
    func add(role: AmityChannelRole, userIds: [String], completion: ((AmityError?) -> Void)?) {
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
    func remove(role: AmityChannelRole, userIds: [String], completion: ((AmityError?) -> Void)?) {
        moderation?.removeRole(role.rawValue, userIds: userIds, completion: { (success, error) in
            if success {
                completion?(nil)
            } else {
                completion?(AmityError(error: error) ?? .unknown)
            }
        })
    }

}
