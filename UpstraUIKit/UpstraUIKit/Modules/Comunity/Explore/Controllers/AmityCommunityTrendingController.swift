//
//  AmityCommunityTrendingController.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/24/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityCommunityTrendingControllerProtocol {
    func retrieve(_ completion: ((Result<[AmityCommunityModel], AmityError>) -> Void)?)
}

final class AmityCommunityTrendingController: AmityCommunityTrendingControllerProtocol {
    
    private let repository = AmityCommunityRepository(client: AmityUIKitManagerInternal.shared.client)
    private var collection: AmityCollection<AmityCommunity>?
    private var token: AmityNotificationToken?
    private let maxTrending: Int = 5
    
    func retrieve(_ completion: ((Result<[AmityCommunityModel], AmityError>) -> Void)?) {
        // Reset previous collection
        token?.invalidate()
        token = nil
        
        collection = repository.getTrendingCommunities()
        token = collection?.observe { [weak self] (collection, change, error) in
            guard let self else { return }
            
            // In case of error, show error
            if let error {
                completion?(.failure(AmityError(error: error) ?? .unknown))
                return
            }
            
            // In case of fetching fresh data, show that data.
            if collection.dataStatus == .fresh {
                if let error = AmityError(error: error) {
                    completion?(.failure(error))
                } else {
                    let communities = processTrendingCommunities(limit: self.maxTrending)
                    completion?(.success(communities))
                }
            }
        }
    }
    
    private func processTrendingCommunities(limit: Int) -> [AmityCommunityModel] {
        guard let collection else { return [] }
        
        let firstFiveItems = collection.snapshots.prefix(limit)
        let communities = firstFiveItems.map { AmityCommunityModel(object: $0) }
        return communities
    }
}
