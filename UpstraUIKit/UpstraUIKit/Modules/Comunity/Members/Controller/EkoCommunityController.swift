//
//  EkoCommunityController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 16/12/2563 BE.
//  Copyright © 2563 BE Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoCommunityController {
    
    private weak var repository: EkoCommunityRepository?
    private var communityId: String
    
    private var token: EkoNotificationToken?
    private var community: EkoObject<EkoCommunity>?
    
    init(repository: EkoCommunityRepository?, communityId: String) {
        self.repository = repository
        self.communityId = communityId
    }
    
    func getCommunity(completion: @escaping (Result<EkoCommunityModel, Error>) -> Void) {
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
                self.token?.invalidate()
            }
            
        }
    }
}
