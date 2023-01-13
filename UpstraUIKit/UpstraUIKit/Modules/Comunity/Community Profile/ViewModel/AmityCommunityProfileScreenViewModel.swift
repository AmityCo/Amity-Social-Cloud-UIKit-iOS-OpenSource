//
//  AmityCommunityProfileScreenViewModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 20/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

enum AmityMemberStatusCommunity: String {
    case guest
    case member
    case admin
}

final class AmityCommunityProfileScreenViewModel: AmityCommunityProfileScreenViewModelType {
    
    weak var delegate: AmityCommunityProfileScreenViewModelDelegate?
    
    // MARK: - Repository Manager
    private let communityRepositoryManager: AmityCommunityRepositoryManagerProtocol
    
    // MARK: - Properties
    let communityId: String
    private(set) var community: AmityCommunityModel?
    private(set) var memberStatusCommunity: AmityMemberStatusCommunity = .guest
    
    var postCount: Int {
        return community?.object.getPostCount(feedType: .published) ?? 0
    }
    
    init(communityId: String,
         communityRepositoryManager: AmityCommunityRepositoryManagerProtocol) {
        self.communityId = communityId
        self.communityRepositoryManager = communityRepositoryManager
    }
    
}

// MARK: - DataSource
extension AmityCommunityProfileScreenViewModel {
    
    func getPendingPostCount(completion: ((Int) -> Void)?) {
        getPendingPostCount(with: .reviewing, completion: completion)
    }
    
    private func getPendingPostCount(with feedType: AmityFeedType, completion: ((Int) -> Void)?) {
        guard let community = community, community.isPostReviewEnabled else {
            completion?(0)
            return
        }
        
        // Return pending post count which is already available locally.
        completion?(community.pendingPostCount)
    }
}

// MARK: - Action

// MARK: Routing
extension AmityCommunityProfileScreenViewModel {
    func route(_ route: AmityCommunityProfileRoute) {
        delegate?.screenViewModelRoute(self, route: route)
    }
    
}

// MARK: - Action
extension AmityCommunityProfileScreenViewModel {
    
    func retriveCommunity() {
        communityRepositoryManager.retrieveCommunity { [weak self] (result) in
            switch result {
            case .success(let community):
                self?.community = community
                self?.prepareDataToShowCommunityProfile(community: community)
            case .failure:
                break
            }
        }
    }
    
    private func prepareDataToShowCommunityProfile(community model: AmityCommunityModel) {
        community = model
        AmityUIKitManagerInternal.shared.client.hasPermission(.editCommunity, forCommunity: communityId) { [weak self] (hasPermission) in
            guard let strongSelf = self else { return }
            if model.isJoined {
                strongSelf.memberStatusCommunity = hasPermission ? .admin : .member
            } else {
                strongSelf.memberStatusCommunity = .guest
            }

            strongSelf.delegate?.screenViewModelDidGetCommunity(with: model)
        }
    }
    
    
    func joinCommunity() {
        communityRepositoryManager.join { [weak self] (error) in
            if let error = error {
                self?.delegate?.screenViewModelFailure()
            } else {
                self?.retriveCommunity()
            }
        }
    }

}
