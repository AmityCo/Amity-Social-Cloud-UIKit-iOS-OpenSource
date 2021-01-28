//
//  EkoCommunityProfileScreenViewModel.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 1/8/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoCommunityProfileScreenViewModel: EkoCommunityProfileScreenViewModelType {
    
    enum CommunityJoinStatus {
        case notJoin
        case joinNotCreator
        case joinAndCreator
    }
    
    weak var delegate: EkoCommunityProfileScreenViewModelDelegate?
    
    // MARK: Controller
    private let userRolesController: EkoCommunityUserRolesControllerProtocol
    private let communityInfoController: EkoCommunityInfoController
    private let communityJoinController: EkoCommunityJoinControllerProtocol
    
    // MARK: - Properties
    var communityId: String = ""
    var community: EkoCommunityModel?
    var isModerator: Bool = false
    
    private var communityJoinStatus: CommunityJoinStatus = .notJoin {
        didSet {
            delegate?.screenViewModelDidJoinCommunity(communityJoinStatus)
        }
    }
    
    init(communityId: String) {
        self.communityId = communityId
        self.userRolesController = EkoCommunityUserRolesController(communityId: communityId)
        self.communityInfoController = EkoCommunityInfoController(communityId: communityId)
        self.communityJoinController = EkoCommunityJoinController(withCommunityId: communityId)
    }
    
    // MARK: - DataSource
    var getCommunityJoinStatus: CommunityJoinStatus {
        return communityJoinStatus
    }
}

// MARK: - DataSource
extension EkoCommunityProfileScreenViewModel {
    
}

// MARK: - Action

// MARK: Routing
extension EkoCommunityProfileScreenViewModel {
    func route(_ route: EkoCommunityProfileRoute) {
        self.delegate?.screenViewModelRoute(self, route: route)
    }
}

// MARK: - Get community info
extension EkoCommunityProfileScreenViewModel {
    
    func getUserRole() {
        isModerator = userRolesController.getUserRoles(withUserId: UpstraUIKitManagerInternal.shared.currentUserId, role: .moderator)
    }
    
    func getCommunity() {
        communityInfoController.getCommunity { [weak self] (result) in
            switch result {
            case .success(let community):
                self?.community = community
                self?.checkingJoinStatus(community: community)
                self?.delegate?.screenViewModelDidGetCommunity(with: community)
            case .failure:
                break
            }
        }
    }
    
    private func checkingJoinStatus(community: EkoCommunityModel) {
        if community.isJoined {
            if (community.isCreator) || isModerator {
                communityJoinStatus = .joinAndCreator
            } else {
                communityJoinStatus = .joinNotCreator
            }
        } else {
            communityJoinStatus = .notJoin
        }
    }
}

// MARK: - Join community
extension EkoCommunityProfileScreenViewModel {
    func joinCommunity() {
        communityJoinController.join { [weak self] (error) in
            if let error = error {
                self?.delegate?.screenViewModelFailure()
            } else {
                self?.delegate?.screenViewModelDidJoinCommunitySuccess()
            }
        }
    }
}
