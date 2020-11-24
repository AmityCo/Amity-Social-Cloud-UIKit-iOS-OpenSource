//
//  EkoCategoryCommunityListScreenViewModel.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 15/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import EkoChat

class EkoCategoryCommunityListScreenViewModel: EkoCategoryCommunityListScreenViewModelType {
    
    private let communityrepository = EkoCommunityRepository(client: UpstraUIKitManager.shared.client)
    private var communityCollection: EkoCollection<EkoCommunity>?
    private var communityToken: EkoNotificationToken?
    
    weak var delegate: EkoCategoryCommunityListScreenViewModelDelegate?
    
    init(categoryId: String) {
        communityCollection = communityrepository.getCommunitiesWithKeyword(nil, filter: .all, sortBy: .lastCreated, categoryId: categoryId, includeDeleted: false)
        communityToken = communityCollection?.observe{ [weak self] _,_,_  in
            guard let strongSelf = self else { return  }
            strongSelf.delegate?.screenViewModelDidUpdateData(strongSelf)
        }
    }
    
    // MARK: - Datasource
    
    func numberOfItems() -> Int {
        return Int(communityCollection?.count() ?? 0)
    }
    
    func item(at indexPath: IndexPath) -> EkoCommunityModel? {
        guard let object = communityCollection?.object(at: UInt(indexPath.row)) else {
            return nil
        }
        return EkoCommunityModel(object: object)
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
