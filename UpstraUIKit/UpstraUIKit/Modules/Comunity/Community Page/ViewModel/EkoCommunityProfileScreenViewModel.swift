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
        case joinAsMember
        case joinAsModerator
    }
    
    weak var delegate: EkoCommunityProfileScreenViewModelDelegate?
    
    // MARK: Controller
    private let userRolesController: EkoCommunityUserRolesControllerProtocol
    private let communityInfoController: EkoCommunityInfoController
    private let communityJoinController: EkoCommunityJoinControllerProtocol
    
    // MARK: - Properties
    var communityId: String = ""
    var community: EkoCommunityModel?
    private var hasEditPermission: Bool = false
    
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
    
    func showCommunitySettingsModal() {
        if EkoCommunityProfilePageViewController.newCreatedCommunityIds.contains(communityId) {
            let firstAction = EkoDefaultModalModel.Action(title: EkoLocalizedStringSet.communitySettings,
                                                          textColor: EkoColorSet.baseInverse,
                                                          backgroundColor: EkoColorSet.primary)
            let secondAction = EkoDefaultModalModel.Action(title: EkoLocalizedStringSet.skipForNow,
                                                           textColor: EkoColorSet.primary,
                                                           font: EkoFontSet.body,
                                                           backgroundColor: .clear)

            let communitySettingsModel = EkoDefaultModalModel(image: EkoIconSet.iconMagicWand,
                                                              title: EkoLocalizedStringSet.Modal.communitySettingsTitle,
                                                              description: EkoLocalizedStringSet.Modal.communitySettingsDesc,
                                                              firstAction: firstAction,
                                                              secondAction: secondAction,
                                                              layout: .vertical)
            EkoCommunityProfilePageViewController.newCreatedCommunityIds.remove(communityId)
            delegate?.screenViewModelShowCommunitySettingsModal(self, withModel: communitySettingsModel)
        }
    }
}

// MARK: - Get community info
extension EkoCommunityProfileScreenViewModel {
    
    func getUserPermission() {
        UpstraUIKitManagerInternal.shared.client.hasPermission(.editCommunity, forCommunity: communityId) { [weak self] (hasEditPermission) in
            self?.hasEditPermission = hasEditPermission
            self?.checkJoiningStatus()
        }
    }
    
    func getCommunity() {
        communityInfoController.getCommunity { [weak self] (result) in
            switch result {
            case .success(let community):
                self?.community = community
                self?.delegate?.screenViewModelDidGetCommunity(with: community)
                self?.checkJoiningStatus()
            case .failure:
                break
            }
        }
    }
    
    private func checkJoiningStatus() {
        if community?.isJoined ?? false {
            if hasEditPermission || (community?.isCreator ?? false) {
                communityJoinStatus = .joinAsModerator
            } else {
                communityJoinStatus = .joinAsMember
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
            if let _ = error {
                self?.delegate?.screenViewModelFailure()
            } else {
                self?.delegate?.screenViewModelDidJoinCommunitySuccess()
            }
        }
    }
}
