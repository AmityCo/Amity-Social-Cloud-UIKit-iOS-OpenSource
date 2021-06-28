//
//  AmityCommunityInfoController.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 1/4/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityCommunityInfoControllerProtocol {
    func getCommunity(_ completion: @escaping (Result<AmityCommunityModel, AmityError>) -> Void)
}

final class AmityCommunityInfoController: AmityCommunityInfoControllerProtocol {
    
    private let repository: AmityCommunityRepository
    private var communityId: String
    private var token: AmityNotificationToken?
    private var community: AmityObject<AmityCommunity>?
    
    init(communityId: String) {
        self.communityId = communityId
        repository = AmityCommunityRepository(client: AmityUIKitManagerInternal.shared.client)
    }
    
    func getCommunity(_ completion: @escaping (Result<AmityCommunityModel, AmityError>) -> Void) {
        community = repository.getCommunity(withId: communityId)
        token = community?.observe { community, error in
            guard let object = community.object else {
                if let error = AmityError(error: error) {
                    completion(.failure(error))
                }
                return
            }
            
            let model = AmityCommunityModel(object: object)
            completion(.success(model))
          
        }
    }
}
