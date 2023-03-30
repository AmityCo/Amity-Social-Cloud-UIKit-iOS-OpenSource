//
//  AmityPostTargetPickerScreenViewModel.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 27/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import AmitySDK
import UIKit

class AmityPostTargetPickerScreenViewModel: AmityPostTargetPickerScreenViewModelType {
    
    weak var delegate: AmityPostTargetPickerScreenViewModelDelegate?
    
    private let communityRepository = AmityCommunityRepository(client: AmityUIKitManagerInternal.shared.client)
    private var communityCollection: AmityCollection<AmityCommunity>?
    private var categoryCollectionToken:AmityNotificationToken?
    
    func observe() {
        let queryOptions = AmityCommunityQueryOptions(displayName: "", filter: .userIsMember, sortBy: .displayName, includeDeleted: false)
        communityCollection = communityRepository.getCommunities(with: queryOptions)
        categoryCollectionToken = communityCollection?.observe({ [weak self] (collection, _, _) in
            guard let strongSelf = self else { return }
            switch collection.dataStatus {
            case .fresh:
                strongSelf.delegate?.screenViewModelDidUpdateItems(strongSelf)
            default: break
            }
        })
    }
    
    func numberOfItems() -> Int {
        return Int(communityCollection?.count() ?? 0)
    }
    
    func community(at indexPath: IndexPath) -> AmityCommunity? {
        return communityCollection?.object(at: indexPath.row)
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
