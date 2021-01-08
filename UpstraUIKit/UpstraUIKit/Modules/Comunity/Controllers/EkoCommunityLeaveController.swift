//
//  EkoCommunityLeaveController.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 1/8/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoCommunityLeaveControllerProtocol {
    func leave(_ completion: @escaping (EkoError?) -> Void)
}

final class EkoCommunityLeaveController: EkoCommunityLeaveControllerProtocol {
    
    private let repository: EkoCommunityRepository
    private let communityId: String
    
    init(withCommunityId _communityId: String) {
        communityId = _communityId
        repository = EkoCommunityRepository(client: UpstraUIKitManagerInternal.shared.client)
    }
    
    
    func leave(_ completion: @escaping (EkoError?) -> Void) {
        repository.leaveCommunity(withCommunityId: communityId) { (success, error) in
            if success {
                completion(nil)
            } else {
                if let error = error {
                    completion(.unknown)
                } else {
                    completion(.unknown)
                }
            }
        }
    }
}

