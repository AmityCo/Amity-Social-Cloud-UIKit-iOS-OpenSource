//
//  AmityChanneluserModeratorController.swift
//  AmityUIKit
//
//  Created by min khant on 12/05/2021.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityChannelUserRolesControllerProtocol {
    func getUserRoles(withUserId userId: String, role: AmityChannelRole, completionHandler: @escaping (Bool) -> ())
}

final class AmityChannelUserRolesController: AmityChannelUserRolesControllerProtocol {
    private var membershipParticipation: AmityChannelParticipation?
    private var membership: AmityChannelMember?
    private var token: AmityNotificationToken?
    
    init(channelId: String) {
        membershipParticipation = AmityChannelParticipation(client: AmityUIKitManagerInternal.shared.client, andChannel: channelId)
    }
    
    func getUserRoles(withUserId userId: String, role: AmityChannelRole, completionHandler: @escaping (Bool) -> ()) {
        token?.invalidate()
        completionHandler(false)
        token = membershipParticipation?.getMembers(filter: .all, sortBy: .lastCreated, roles: []).observe({ [weak self] collection, change, error in
            guard let weakSelf = self else { return }
            if error != nil {
                completionHandler(false)
            } else {
                var result = false
                for index in 0..<collection.count() {
                    guard let member = collection.object(at: index) else { continue }
                    if member.userId == userId {
                        result = member.roles.contains(role.rawValue)
                        break
                    }
                }
                switch collection.dataStatus {
                case .fresh, .error:
                    weakSelf.token?.invalidate()
                default:
                    break
                }
                completionHandler(result)
            }
        })
    }
}
