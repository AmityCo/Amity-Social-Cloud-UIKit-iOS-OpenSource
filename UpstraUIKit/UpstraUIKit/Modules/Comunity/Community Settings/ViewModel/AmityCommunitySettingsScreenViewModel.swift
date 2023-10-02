//
//  AmityCommunitySettingsScreenViewModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 10/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import AmitySDK
import UIKit

final class AmityCommunitySettingsScreenViewModel: AmityCommunitySettingsScreenViewModelType {
    weak var delegate: AmityCommunitySettingsScreenViewModelDelegate?
    
    // MARK: - Controller
    private let userNotificationController: AmityUserNotificationSettingsControllerProtocol
    private let communityNotificationController: AmityCommunityNotificationSettingsControllerProtocol
    private let communityLeaveController: AmityCommunityLeaveControllerProtocol
    private let communityDeleteController: AmityCommunityDeleteControllerProtocol
    private let communityInfoController: AmityCommunityInfoControllerProtocol
    private let userRolesController: AmityCommunityUserRolesControllerProtocol
    
    // MARK: - SubViewModel
    private var menuViewModel: AmityCommunitySettingsCreateMenuViewModelProtocol?
    
    // MARK: - Properties
    private(set) var community: AmityCommunityModel?
    let communityId: String
    private var isNotificationEnabled: Bool = false
    private var isSocialNetworkEnabled: Bool = false
    private var isSocialUserEnabled: Bool = false
    
    init(communityId: String,
         userNotificationController: AmityUserNotificationSettingsControllerProtocol,
         communityNotificationController: AmityCommunityNotificationSettingsControllerProtocol,
         communityLeaveController: AmityCommunityLeaveControllerProtocol,
         communityDeleteController: AmityCommunityDeleteControllerProtocol,
         communityInfoController: AmityCommunityInfoControllerProtocol,
         userRolesController: AmityCommunityUserRolesControllerProtocol) {
        self.communityId = communityId
        self.userNotificationController = userNotificationController
        self.communityNotificationController = communityNotificationController
        self.communityLeaveController = communityLeaveController
        self.communityDeleteController = communityDeleteController
        self.communityInfoController = communityInfoController
        self.userRolesController = userRolesController
    }
}

// MARK: - DataSource
extension AmityCommunitySettingsScreenViewModel {
    func isModerator(userId: String) -> Bool {
        return userRolesController.getUserRoles(withUserId: userId, role: .moderator) || userRolesController.getUserRoles(withUserId: userId, role: .communityModerator)
    }
}

// MARK: - Action
extension AmityCommunitySettingsScreenViewModel {
    func retrieveCommunity() {
        communityInfoController.getCommunity { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let community):
                strongSelf.community = community
                strongSelf.retrieveSettingsMenu()
                strongSelf.delegate?.screenViewModel(strongSelf, didGetCommunitySuccess: community)
            case .failure:
                break
            }
        }
    }
    
    func retrieveNotifcationSettings() {
        userNotificationController.retrieveNotificationSettings { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let notification):
                if let socialModule = notification.modules.first(where: { $0.moduleType == .social }) {
                    strongSelf.isSocialUserEnabled = socialModule.isEnabled
                    strongSelf.retrieveSettingsMenu()
                }
                break
            case .failure:
                break
            }
        }
        communityNotificationController.retrieveNotificationSettings { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let notification):
                strongSelf.isNotificationEnabled = notification.isEnabled
                strongSelf.isSocialNetworkEnabled = notification.isSocialNetworkEnabled
                strongSelf.retrieveSettingsMenu()
            break
            case .failure:
                break
            }
        }
    }
    
    func retrieveSettingsMenu() {
        guard let community = community else { return }
        let userRolesController: AmityCommunityUserRolesControllerProtocol = AmityCommunityUserRolesController(communityId: community.communityId)
        menuViewModel = AmityCommunitySettingsCreateMenuViewModel(community: community, userRolesController: userRolesController)
        menuViewModel?.createSettingsItems(shouldNotificationItemShow: isSocialUserEnabled && isSocialNetworkEnabled, isNotificationEnabled: isNotificationEnabled) { [weak self] (items) in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.screenViewModel(strongSelf, didGetSettingMenu: items)
        }
    }
    
    func leaveCommunity() {
        communityLeaveController.leave { [weak self] (error) in
            guard let strongSelf = self else { return }
            if let error = error {
                switch error {
                case .noPermission, .unableToLeaveCommunity:
                    strongSelf.delegate?.screenViewModel(strongSelf, failure: error)
                default:
                    strongSelf.delegate?.screenViewModelDidLeaveCommunityFail()
                }
            } else {
                strongSelf.delegate?.screenViewModelDidLeaveCommunity()
            }
        }
    }
    
    func closeCommunity() {
        communityDeleteController.delete { [weak self] (error) in
            guard let strongSelf = self else { return }
            if let error = error {
                switch error {
                case .noPermission:
                    strongSelf.delegate?.screenViewModel(strongSelf, failure: error)
                default:
                    strongSelf.delegate?.screenViewModelDidCloseCommunityFail()
                }
            } else {
                strongSelf.delegate?.screenViewModelDidCloseCommunity()
            }
        }
    }
}
