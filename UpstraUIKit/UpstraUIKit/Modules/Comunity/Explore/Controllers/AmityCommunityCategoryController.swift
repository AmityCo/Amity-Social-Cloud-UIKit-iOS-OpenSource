//
//  AmityCommunityCategoryController.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/24/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityCommunityCategoryControllerProtocol {
    func retrieve(_ completion: ((Result<[AmityCommunityCategoryModel], AmityError>) -> Void)?)
}

final class AmityCommunityCategoryController: AmityCommunityCategoryControllerProtocol {
    
    private let repository = AmityCommunityRepository(client: AmityUIKitManagerInternal.shared.client)
    private var collection: AmityCollection<AmityCommunityCategory>?
    private var token: AmityNotificationToken?
    private let maxCategories: Int = 8
    
    func retrieve(_ completion: ((Result<[AmityCommunityCategoryModel], AmityError>) -> Void)?) {
        token?.invalidate()
        token = nil
        
        collection = repository.getCategories(sortBy: .displayName, includeDeleted: false)
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
                    completion?(.success(self.processCategories(limit: self.maxCategories)))
                }
            }
        }
    }
    
    private func processCategories(limit: Int) -> [AmityCommunityCategoryModel] {
        guard let collection else { return [] }
        
        let limitedItems = collection.snapshots.prefix(limit)
        let categories = limitedItems.map { AmityCommunityCategoryModel(object: $0) }
        return categories
    }
}
