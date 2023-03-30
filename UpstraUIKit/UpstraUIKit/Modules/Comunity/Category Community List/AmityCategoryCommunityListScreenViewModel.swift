//
//  AmityCategoryCommunityListScreenViewModel.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 15/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import AmitySDK

class AmityCategoryCommunityListScreenViewModel: AmityCategoryCommunityListScreenViewModelType {
    
    private let communityrepository = AmityCommunityRepository(client: AmityUIKitManagerInternal.shared.client)
    private var communityCollection: AmityCollection<AmityCommunity>?
    private var communityToken: AmityNotificationToken?
    
    weak var delegate: AmityCategoryCommunityListScreenViewModelDelegate?
    
    init(categoryId: String) {
        let queryOptions = AmityCommunityQueryOptions(filter: .all, sortBy: .displayName, categoryId: categoryId, includeDeleted: false)
        communityCollection = communityrepository.getCommunities(with: queryOptions)
        communityToken = communityCollection?.observe{ [weak self] _,_,_  in
            guard let strongSelf = self else { return  }
            strongSelf.delegate?.screenViewModelDidUpdateData(strongSelf)
        }
    }
    
    // MARK: - Datasource
    
    func numberOfItems() -> Int {
        return Int(communityCollection?.count() ?? 0)
    }
    
    func item(at indexPath: IndexPath) -> AmityCommunityModel? {
        guard let object = communityCollection?.object(at: indexPath.row) else {
            return nil
        }
        return AmityCommunityModel(object: object)
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
