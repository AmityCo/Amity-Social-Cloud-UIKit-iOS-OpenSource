//
//  EkoCommunitySettingsScreenViewModel.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 10/3/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import EkoChat
import UIKit

final class EkoCommunitySettingsScreenViewModel: EkoCommunitySettingsScreenViewModelType {
    weak var delegate: EkoCommunitySettingsScreenViewModelDelegate?
    
    // MARK: - Controller
    private let userNotificationController: EkoUserNotificationSettingsControllerProtocol
    private let communityNotificationController: EkoCommunityNotificationSettingsControllerProtocol
    private let communityLeaveController: EkoCommunityLeaveControllerProtocol
    private let communityDeleteController: EkoCommunityDeleteControllerProtocol
    private let communityInfoController: EkoCommunityInfoControllerProtocol
    
    // MARK: - SubViewModel
    private var menuViewModel: EkoCommunitySettingsCreateMenuViewModelProtocol?
    
    // MARK: - Properties
    var community: EkoCommunityModel
    private var isNotificationEnabled: Bool = false
    private var isSocialNetworkEnabled: Bool = false
    private var isSocialUserEnabled: Bool = false
    
    init(community: EkoCommunityModel,
         userNotificationController: EkoUserNotificationSettingsControllerProtocol,
         communityNotificationController: EkoCommunityNotificationSettingsControllerProtocol,
         communityLeaveController: EkoCommunityLeaveControllerProtocol,
         communityDeleteController: EkoCommunityDeleteControllerProtocol,
         communityInfoController: EkoCommunityInfoControllerProtocol) {
        self.community = community
        self.userNotificationController = userNotificationController
        self.communityNotificationController = communityNotificationController
        self.communityLeaveController = communityLeaveController
        self.communityDeleteController = communityDeleteController
        self.communityInfoController = communityInfoController
    }
}

// MARK: - DataSource
extension EkoCommunitySettingsScreenViewModel {
    
}

// MARK: - Action
extension EkoCommunitySettingsScreenViewModel {
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
        menuViewModel = EkoCommunitySettingsCreateMenuViewModel(community: community)
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
                case .noPermission:
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
