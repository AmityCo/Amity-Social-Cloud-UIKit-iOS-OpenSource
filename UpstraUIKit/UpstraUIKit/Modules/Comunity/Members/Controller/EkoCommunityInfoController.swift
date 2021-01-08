//
//  EkoCommunityInfoController.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 1/4/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoCommunityInfoController {
    
    private var repository: EkoCommunityRepository?
    private var communityId: String
    private var token: EkoNotificationToken?
    private var community: EkoObject<EkoCommunity>?
    
    init(communityId: String) {
        self.communityId = communityId
        repository = EkoCommunityRepository(client: UpstraUIKitManagerInternal.shared.client)
    }
    
    func getCommunity(_ completion: @escaping (Result<EkoCommunityModel, Error>) -> Void) {
        community = repository?.getCommunity(withId: communityId)
        token = community?.observe { community, error in
            if community.dataStatus == .fresh {
                guard error == nil, let object = community.object else {
                    guard let error = error else { return }
                    completion(.failure(error))
                    return
                }
                
                let model = EkoCommunityModel(object: object)
                completion(.success(model))
            }
        }
    }
}
