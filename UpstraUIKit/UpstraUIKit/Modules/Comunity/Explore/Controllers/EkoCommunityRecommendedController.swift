//
//  EkoCommunityRecommendedController.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/24/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoCommunityRecommendedControllerProtocol {
    func retrieve(_ completion: ((Result<[EkoCommunityModel], EkoError>) -> Void)?)
}

final class EkoCommunityRecommendedController: EkoCommunityRecommendedControllerProtocol {
    
    private let repository = EkoCommunityRepository(client: UpstraUIKitManagerInternal.shared.client)
    private var collection: EkoCollection<EkoCommunity>?
    private var token: EkoNotificationToken?
    private let maxRecommended: UInt = 4
    
    func retrieve(_ completion: ((Result<[EkoCommunityModel], EkoError>) -> Void)?) {
        collection = repository.getRecommendedCommunities()
        token = collection?.observe { [weak self] (collection, change, error) in
            if collection.dataStatus == .fresh {
                guard let strongSelf = self else { return }
                if let error = EkoError(error: error) {
                    completion?(.failure(error))
                } else {
                    completion?(.success(strongSelf.prepareDataSource()))
                }
            } else {
                completion?(.failure(EkoError(error: error) ?? .unknown))
            }
        }
    }
    
    private func prepareDataSource() -> [EkoCommunityModel] {
        guard let collection = collection else { return [] }
        var community: [EkoCommunityModel] = []
        for index in 0..<min(collection.count(), maxRecommended) {
            guard let object = collection.object(at: index) else { continue }
            let model = EkoCommunityModel(object: object)
            community.append(model)
        }
        return community
    }
    
}
