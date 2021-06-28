//
//  AmityCommunityProfileScreenViewModel.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 1/8/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

final class AmityCommunityProfileScreenViewModel: AmityCommunityProfileScreenViewModelType {
    
    enum CommunityJoinStatus {
        case notJoin
        case joinNotCreator
        case joinAndCreator
    }
    
    weak var delegate: AmityCommunityProfileScreenViewModelDelegate?
    
    // MARK: Controller
    private let userRolesController: AmityCommunityUserRolesControllerProtocol
    private let communityInfoController: AmityCommunityInfoController
    private let communityJoinController: AmityCommunityJoinControllerProtocol
    
    // MARK: - Properties
    var communityId: String = ""
    var community: AmityCommunityModel?
    var isModerator: Bool = false
    
    private var communityJoinStatus: CommunityJoinStatus = .notJoin {
        didSet {
            delegate?.screenViewModelDidJoinCommunity(communityJoinStatus)
        }
    }
    
    init(communityId: String) {
        self.communityId = communityId
        self.userRolesController = AmityCommunityUserRolesController(communityId: communityId)
        self.communityInfoController = AmityCommunityInfoController(communityId: communityId)
        self.communityJoinController = AmityCommunityJoinController(withCommunityId: communityId)
    }
    
    // MARK: - DataSource
    var getCommunityJoinStatus: CommunityJoinStatus {
        return communityJoinStatus
    }
}

// MARK: - DataSource
extension AmityCommunityProfileScreenViewModel {
    
}

// MARK: - Action

// MARK: Routing
extension AmityCommunityProfileScreenViewModel {
    func route(_ route: AmityCommunityProfileRoute) {
        self.delegate?.screenViewModelRoute(self, route: route)
    }
    
    func showCommunitySettingsModal() {
        if AmityCommunityProfilePageViewController.newCreatedCommunityIds.contains(communityId) {
            let firstAction = AmityDefaultModalModel.Action(title: AmityLocalizedStringSet.communitySettings,
                                                          textColor: AmityColorSet.baseInverse,
                                                          backgroundColor: AmityColorSet.primary)
            let secondAction = AmityDefaultModalModel.Action(title: AmityLocalizedStringSet.skipForNow,
                                                           textColor: AmityColorSet.primary,
                                                           font: AmityFontSet.body,
                                                           backgroundColor: .clear)

            let communitySettingsModel = AmityDefaultModalModel(image: AmityIconSet.iconMagicWand,
                                                              title: AmityLocalizedStringSet.Modal.communitySettingsTitle,
                                                              description: AmityLocalizedStringSet.Modal.communitySettingsDesc,
                                                              firstAction: firstAction,
                                                              secondAction: secondAction,
                                                              layout: .vertical)
            AmityCommunityProfilePageViewController.newCreatedCommunityIds.remove(communityId)
            delegate?.screenViewModelShowCommunitySettingsModal(self, withModel: communitySettingsModel)
        }
    }
}

// MARK: - Get community info
extension AmityCommunityProfileScreenViewModel {
    
    func getUserRole() {
        isModerator = userRolesController.getUserRoles(withUserId: AmityUIKitManagerInternal.shared.currentUserId, role: .moderator)
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
    
    private func checkingJoinStatus(community: AmityCommunityModel) {
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
extension AmityCommunityProfileScreenViewModel {
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
