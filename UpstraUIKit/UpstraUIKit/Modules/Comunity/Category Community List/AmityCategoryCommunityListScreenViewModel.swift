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
        communityCollection = communityrepository.getCommunities(displayName: nil, filter: .all, sortBy: .displayName, categoryId: categoryId, includeDeleted: false)
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
        guard let object = communityCollection?.object(at: UInt(indexPath.row)) else {
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

//MARK: Action
extension AmityCategoryCommunityListScreenViewModel {
    
    func join(community: AmityCommunityModel) {
        communityrepository.joinCommunity(withId: community.communityId) { [weak self] (success, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.delegate?.didJoinedCommunityFailure(error: error)
                
                return
            }
            
            let userInfo = ["communityId": community.communityId as Any]
//            NotificationCenter.default.post(name: NSNotification.Name.Post.didJoinCommunity, object: nil, userInfo: userInfo)
            self.delegate?.didJoinedCommunitySuccess(community: community)
        }
    }
    
    func leave(community: AmityCommunityModel) {
        communityrepository.leaveCommunity(withId: community.communityId) { [weak self] (success, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.delegate?.didLeavedCommunityFailure(error: error)
                return
            }
            
            let userInfo = ["communityId": community.communityId as Any]
            //        NotificationCenter.default.post(name: NSNotification.Name.Post.didLeaveCommunity, object: nil, userInfo: userInfo)
            self.delegate?.didLeavedCommunitySuccess(community: community)
        }
    }
    
}
