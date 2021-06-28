//
//  AmityCommunityLeaveController.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 1/8/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityCommunityLeaveControllerProtocol {
    func leave(_ completion: @escaping (AmityError?) -> Void)
}

final class AmityCommunityLeaveController: AmityCommunityLeaveControllerProtocol {
    
    private let repository: AmityCommunityRepository
    private let communityId: String
    
    init(withCommunityId _communityId: String) {
        communityId = _communityId
        repository = AmityCommunityRepository(client: AmityUIKitManagerInternal.shared.client)
    }
    
    func leave(_ completion: @escaping (AmityError?) -> Void) {
        repository.leaveCommunity(withId: communityId) { (success, error) in
            if success {
                completion(nil)
            } else {
                completion(AmityError(error: error))
            }
        }
    }
    
}

