//
//  EkoCommunityJoinController.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 1/8/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoCommunityJoinControllerProtocol {
    func join(_ completion: @escaping (EkoError?) -> Void)
}

final class EkoCommunityJoinController: EkoCommunityJoinControllerProtocol {
    
    private let repository: EkoCommunityRepository
    private let communityId: String
    
    init(withCommunityId _communityId: String) {
        communityId = _communityId
        repository = EkoCommunityRepository(client: UpstraUIKitManagerInternal.shared.client)
    }
    
    
    func join(_ completion: @escaping (EkoError?) -> Void) {
        repository.joinCommunity(withCommunityId: communityId) { (success, error) in
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

