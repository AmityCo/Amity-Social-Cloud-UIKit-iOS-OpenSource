//
//  AmityTrendingCommunityScreenViewModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 7/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK
import AVFoundation
final class AmityTrendingCommunityScreenViewModel: AmityTrendingCommunityScreenViewModelType {
    
    weak var delegate: AmityTrendingCommunityScreenViewModelDelegate?
    private var communityRepository:AmityCommunityRepository = AmityCommunityRepository(client: AmityUIKitManager.client)
    
    // MARK: - Controller
    private let trendingController: AmityCommunityTrendingControllerProtocol
    
    // MARK: - Properties
    private var communities: [AmityCommunityModel] = []
    private let debouncer = Debouncer(delay: 0.3)
    
    init(trendingController: AmityCommunityTrendingControllerProtocol) {
        self.trendingController = trendingController
    }
    
}

// MARK: - DataSource {
extension AmityTrendingCommunityScreenViewModel {
    
    func numberOfTrending() -> Int {
        return communities.count
    }
    
    func community(at indexPath: IndexPath) -> AmityCommunityModel {
        return communities[indexPath.row]
    }

}

// MARK: - Action
extension AmityTrendingCommunityScreenViewModel {
    func retrieveTrending() {
        trendingController.retrieve { [weak self] result in
            self?.debouncer.run {
                guard let strongSelf = self else { return }
                switch result {
                case .success(let community):
                    strongSelf.communities = community
                    strongSelf.delegate?.screenViewModel(strongSelf, didRetrieveTrending: community, isEmpty: community.isEmpty)
                case .failure(let error):
                    strongSelf.delegate?.screenViewModel(strongSelf, didFail: error)
                }
            }
        }
    }
    
    func joinCommunity(community: AmityCommunityModel) {
        communityRepository.joinCommunity(withId: community.communityId) { [weak self] (status, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.delegate?.didJoinFailure(error: AmityError(error: error) ?? .unknown)
                return
            }
            if status {
                strongSelf.retrieveTrending()
            }
            return
        }
    }
    
    func leaveCommunity(community: AmityCommunityModel) {
        communityRepository.leaveCommunity(withId: community.communityId) { [weak self] (status, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.delegate?.didLeaveFailure(error: AmityError(error: error) ?? . unknown)
                return
            }
            if status {
                strongSelf.retrieveTrending()
            }
            return
        }
    }
   

}
