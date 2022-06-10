//
//  AmityCommunityListRepositoryManager.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 24/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityCommunityListRepositoryManagerProtocol {
    func search(withText text: String?, filter: AmityCommunityQueryFilter, _ completion: (([AmityCommunityModel]) -> Void)?)
    func loadMore()
}

final class AmityCommunityListRepositoryManager: AmityCommunityListRepositoryManagerProtocol {
    
    private let repository: AmityCommunityRepository
    private var collection: AmityCollection<AmityCommunity>?
    private var token: AmityNotificationToken?
    
    init() {
        repository = AmityCommunityRepository(client: AmityUIKitManagerInternal.shared.client)
    }
    
    func search(withText text: String?, filter: AmityCommunityQueryFilter, _ completion: (([AmityCommunityModel]) -> Void)?) {
        collection = repository.getCommunities(displayName: text, filter: filter, sortBy: .displayName, categoryId: nil, includeDeleted: false)
//        token?.invalidate()
        token = collection?.observe { (collection, change, error) in
//            if collection.dataStatus == .fresh {
                var communityList: [AmityCommunityModel] = []
                for index in 0..<collection.count() {
                    guard let object = collection.object(at: index) else { continue }
                    let model = AmityCommunityModel(object: object)
                    communityList.append(model)
                }
                completion?(communityList)
//            }
        }
    }
    
    func loadMore() {
        guard let collection = collection else { return }
        switch collection.loadingStatus {
        case .loaded:
            if collection.hasNext {
                collection.nextPage()
            }
        default:
            break
        }
    }
}
