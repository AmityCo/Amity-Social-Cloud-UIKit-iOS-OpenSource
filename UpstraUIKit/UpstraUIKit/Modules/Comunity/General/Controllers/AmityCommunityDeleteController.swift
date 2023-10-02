//
//  AmityCommunityDeleteController.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 1/8/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityCommunityDeleteControllerProtocol {
    func delete(_ completion: @escaping (AmityError?) -> Void)
}

final class AmityCommunityDeleteController: AmityCommunityDeleteControllerProtocol {
    
    private let repository: AmityCommunityRepository
    private let communityId: String
    
    init(withCommunityId _communityId: String) {
        communityId = _communityId
        repository = AmityCommunityRepository(client: AmityUIKitManagerInternal.shared.client)
    }
    
    func delete(_ completion: @escaping (AmityError?) -> Void) {
        repository.deleteCommunity(withId: communityId) { (success, error) in
            if success {
                completion(nil)
            } else {
                completion(AmityError(error: error) ?? .unknown)
            }
        }
    }
    
}

