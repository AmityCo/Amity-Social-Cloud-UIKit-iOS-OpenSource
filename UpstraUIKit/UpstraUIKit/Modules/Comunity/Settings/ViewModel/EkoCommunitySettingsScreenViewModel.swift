//
//  EkoCommunitySettingsScreenViewModel.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 1/8/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

final class EkoCommunitySettingsScreenViewModel: EkoCommunitySettingsScreenViewModelType {
    weak var delegate: EkoCommunitySettingsScreenViewModelDelegate?
    
    // MARK: - Controller
    private let communityLeaveController: EkoCommunityLeaveControllerProtocol
    private let communityDeleteController: EkoCommunityDeleteControllerProtocol
    private let userRolesController: EkoCommunityUserRolesControllerProtocol
    
    // MARK: - Properties
    var community: EkoCommunityModel
    var isModerator: Bool = false
    
    init(community: EkoCommunityModel,
         communityLeaveController: EkoCommunityLeaveControllerProtocol,
         communityDeleteController: EkoCommunityDeleteControllerProtocol,
         userRolesController: EkoCommunityUserRolesControllerProtocol) {
        self.community = community
        self.communityLeaveController = communityLeaveController
        self.communityDeleteController = communityDeleteController
        self.userRolesController = userRolesController
    }
}

// MARK: - DataSource
extension EkoCommunitySettingsScreenViewModel {
    
    func getUserRoles() {
        isModerator = userRolesController.getUserRoles(withUserId: UpstraUIKitManagerInternal.shared.currentUserId, role: .moderator)
    }
    
    func leaveCommunity() {
        communityLeaveController.leave { [weak self] (error) in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.delegate?.screenViewModel(strongSelf, failure: error)
            } else {
                strongSelf.delegate?.screenViewModel(strongSelf, didLeaveCommunitySuccess: true)
            }
        }
    }
    
    func deleteCommunity() {
        communityDeleteController.delete { [weak self] (error) in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.delegate?.screenViewModel(strongSelf, failure: error)
            } else {
                strongSelf.delegate?.screenViewModel(strongSelf, didDeleteCommunitySuccess: true)	
            }
        }
    }
}

// MARK: - Action
extension EkoCommunitySettingsScreenViewModel {
    
}
