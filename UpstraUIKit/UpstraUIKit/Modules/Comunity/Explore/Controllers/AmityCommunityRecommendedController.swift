//
//  AmityCommunityRecommendedController.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/24/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityCommunityRecommendedControllerProtocol {
    func retrieve(_ completion: ((Result<[AmityCommunityModel], AmityError>) -> Void)?)
}

final class AmityCommunityRecommendedController: AmityCommunityRecommendedControllerProtocol {
    
    private let repository = AmityCommunityRepository(client: AmityUIKitManagerInternal.shared.client)
    private var collection: AmityCollection<AmityCommunity>?
    private var token: AmityNotificationToken?
    private let maxRecommended: Int = 4
    
    func retrieve(_ completion: ((Result<[AmityCommunityModel], AmityError>) -> Void)?) {
        // Reset previous collection
        token?.invalidate()
        token = nil
        
        collection = repository.getRecommendedCommunities()
        token = collection?.observe { [weak self] (collection, change, error) in
            guard let self else { return }
            
            if let error {
                completion?(.failure(AmityError(error: error) ?? .unknown))
                return
            }
            
            if collection.dataStatus == .fresh {
                if let error = AmityError(error: error) {
                    completion?(.failure(error))
                } else {
                    let communities = processRecommendedCommunities(limit: self.maxRecommended)
                    completion?(.success(communities))
                }
            }
        }
    }
    
    private func processRecommendedCommunities(limit: Int) -> [AmityCommunityModel] {
        guard let collection else { return [] }
        
        let limitedItems = collection.snapshots.prefix(limit)
        let communities = limitedItems.map { AmityCommunityModel(object: $0) }
        return communities
    }
}
