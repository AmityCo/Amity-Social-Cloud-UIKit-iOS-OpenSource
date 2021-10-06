//
//  EkoCommunityMemberSettingsScreenViewModel.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 1/11/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import Foundation

final class EkoCommunityMemberSettingsScreenViewModel: EkoCommunityMemberSettingsScreenViewModelType {
    
    // MARK: - Delegate
    weak var delegate: EkoCommunityMemberSettingsScreenViewModelDelegate?
    
    // MARK: - Controller
    private let userRolesController: EkoCommunityUserRolesControllerProtocol
    
    // MARK: - Properties
    var community: EkoCommunityModel
    var shouldShowAddMemberButton: Bool = false
    
    // MARK: - initial
    init(community: EkoCommunityModel,
         userRolesController: EkoCommunityUserRolesControllerProtocol) {
        self.community = community
        self.userRolesController = userRolesController
    }
}

// MARK: - DataSource
extension EkoCommunityMemberSettingsScreenViewModel {
    
}

// MARK: - Action
extension EkoCommunityMemberSettingsScreenViewModel {
    func getUserPermission() {
        UpstraUIKitManagerInternal.shared.client.hasPermission(.editCommunity, forCommunity: community.communityId) { [weak self] (hasEditPermission) in
            guard let strongSelf = self else { return }
            if strongSelf.community.isJoined {
                self?.delegate?.screenViewModelShouldShowAddButtonBarItem(status: hasEditPermission)
            } else {
                self?.delegate?.screenViewModelShouldShowAddButtonBarItem(status: false)
            }
        }
    }
}
