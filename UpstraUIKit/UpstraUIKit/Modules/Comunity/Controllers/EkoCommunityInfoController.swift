//
//  EkoCommunityInfoController.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 1/4/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoCommunityInfoControllerProtocol {
    func getCommunity(_ completion: @escaping (Result<EkoCommunityModel, EkoError>) -> Void)
}

final class EkoCommunityInfoController: EkoCommunityInfoControllerProtocol {
    
    private let repository: EkoCommunityRepository
    private var communityId: String
    private var token: EkoNotificationToken?
    private var community: EkoObject<EkoCommunity>?
    
    init(communityId: String) {
        self.communityId = communityId
        repository = EkoCommunityRepository(client: UpstraUIKitManagerInternal.shared.client)
    }
    
    func getCommunity(_ completion: @escaping (Result<EkoCommunityModel, EkoError>) -> Void) {
        community = repository.getCommunity(withId: communityId)
        token = community?.observe { community, error in
            guard let object = community.object else {
                if let error = EkoError(error: error) {
                    completion(.failure(error))
                }
                return
            }
            
            let model = EkoCommunityModel(object: object)
            completion(.success(model))
          
        }
    }
}
