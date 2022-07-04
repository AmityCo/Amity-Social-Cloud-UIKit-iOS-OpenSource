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
    var isModerator: Bool = false
    var postId: String?
    var fromDeeplinks: Bool
    
    var postCount: Int {
        return community?.object.getPostCount(feedType: .published) ?? 0
    }
    
    init(communityId: String, postId: String? = nil, fromDeeplinks: Bool = false,
         communityRepositoryManager: AmityCommunityRepositoryManagerProtocol) {
        self.communityId = communityId
        self.communityRepositoryManager = communityRepositoryManager
        self.postId = postId
        self.fromDeeplinks = fromDeeplinks
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
        
        communityRepositoryManager.getPendingPostsCount(by: feedType) { (result) in
            switch result {
            case .success(let postCount):
                completion?(postCount)
            case .failure(_):
                completion?(0)
            }
        }
    }
    
    func shouldShowPendingPostBannerForMember(_ completion: ((Bool) -> Void)?) {
        guard let community = community, community.isPostReviewEnabled else {
            completion?(false)
            return
        }
        
        communityRepositoryManager.getPendingPostsCount(by: .reviewing) { (result) in
            switch result {
            case .success(let postCount):
                completion?(postCount != 0)
            case .failure(_):
                completion?(false)
            }
        }
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
                self?.delegate?.screenViewModelRouteDeeplink()
            case .failure:
                self?.delegate?.screenViewModelDidShowAlertDialog()
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
