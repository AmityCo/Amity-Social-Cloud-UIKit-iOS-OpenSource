//
//  EkoPostToScreenViewModel.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 27/8/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import EkoChat
import UIKit

#warning("should be renamed to PostTargetSelectionScreenViewModel")
class EkoPostToScreenViewModel: EkoPostToScreenViewModelType {
    
    weak var delegate: EkoPostToScreenViewModelDelegate?
    
    private let communityRepository = EkoCommunityRepository(client: UpstraUIKitManagerInternal.shared.client)
    private var communityCollection: EkoCollection<EkoCommunity>?
    private var categoryCollectionToken:EkoNotificationToken?
    
    func observe() {
        communityCollection = communityRepository.getCommunitiesWithKeyword("", filter: .userIsMember, sortBy: .firstCreated, categoryId: nil, includeDeleted: false)
        categoryCollectionToken = communityCollection?.observe({ [weak self] (collection, _, _) in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.screenViewModelDidUpdateItems(strongSelf)
        })
    }
    
    func numberOfItems() -> Int {
        return Int(communityCollection?.count() ?? 0)
    }
    
    func community(at indexPath: IndexPath) -> EkoCommunityModel? {
        guard let community = communityCollection?.object(at: UInt(indexPath.row)) else { return nil }
        let model = EkoCommunityModel(object: community)
        return model
    }
    
    func loadNext() {
        guard let collection = communityCollection else { return }
        switch collection.loadingStatus {
        case .loaded:
            collection.nextPage()
        default:
            break
        }
    }
    
}
