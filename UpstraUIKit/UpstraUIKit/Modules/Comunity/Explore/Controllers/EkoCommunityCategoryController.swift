//
//  EkoCommunityCategoryController.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/24/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoCommunityCategoryControllerProtocol {
    func retrieve(_ completion: ((Result<[EkoCommunityCategoryModel], EkoError>) -> Void)?)
}

final class EkoCommunityCategoryController: EkoCommunityCategoryControllerProtocol {
    
    private let repository = EkoCommunityRepository(client: UpstraUIKitManagerInternal.shared.client)
    private var collection: EkoCollection<EkoCommunityCategory>?
    private var token: EkoNotificationToken?
    private let maxCategories: UInt = 8
    
    func retrieve(_ completion: ((Result<[EkoCommunityCategoryModel], EkoError>) -> Void)?) {
        collection = repository.getAllCategories(.displayName, includeDeleted: false)
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
    
    private func prepareDataSource() -> [EkoCommunityCategoryModel] {
        guard let collection = collection else { return [] }
        var category: [EkoCommunityCategoryModel] = []
        for index in 0..<min(collection.count(), maxCategories) {
            guard let object = collection.object(at: index) else { continue }
            let model = EkoCommunityCategoryModel(object: object)
            category.append(model)
        }
        return category
    }

}
