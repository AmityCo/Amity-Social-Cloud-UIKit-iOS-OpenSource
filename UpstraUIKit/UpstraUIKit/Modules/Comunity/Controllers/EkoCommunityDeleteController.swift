//
//  EkoCommunityDeleteController.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 1/8/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoCommunityDeleteControllerProtocol {
    func delete(_ completion: @escaping (EkoError?) -> Void)
}

final class EkoCommunityDeleteController: EkoCommunityDeleteControllerProtocol {
    
    private let repository: EkoCommunityRepository
    private let communityId: String
    
    init(withCommunityId _communityId: String) {
        communityId = _communityId
        repository = EkoCommunityRepository(client: UpstraUIKitManagerInternal.shared.client)
    }
    
    func delete(_ completion: @escaping (EkoError?) -> Void) {
        repository.deleteCommunity(withId: communityId) { (success, error) in
            if success {
                completion(nil)
            } else {
                completion(EkoError(error: error) ?? .unknown)
            }
        }
    }
    
}

