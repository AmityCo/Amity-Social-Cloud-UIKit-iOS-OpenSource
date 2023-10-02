//
//  AmityCommunityMemberSettingsScreenViewModel.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 1/11/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import Foundation

final class AmityCommunityMemberSettingsScreenViewModel: AmityCommunityMemberSettingsScreenViewModelType {
    
    // MARK: - Delegate
    weak var delegate: AmityCommunityMemberSettingsScreenViewModelDelegate?
    
    // MARK: - Controller
    private let userRolesController: AmityCommunityUserRolesControllerProtocol
    
    // MARK: - Properties
    var community: AmityCommunityModel
    var isModerator: Bool = false
    var shouldShowAddMemberButton: Bool = false
    
    // MARK: - initial
    init(community: AmityCommunityModel,
         userRolesController: AmityCommunityUserRolesControllerProtocol) {
        self.community = community
        self.userRolesController = userRolesController
    }
}

// MARK: - DataSource
extension AmityCommunityMemberSettingsScreenViewModel {
    
}

// MARK: - Action
extension AmityCommunityMemberSettingsScreenViewModel {
    func getUserRoles() {
        isModerator = userRolesController.getUserRoles(withUserId: AmityUIKitManagerInternal.shared.currentUserId, role: .moderator) ||
            userRolesController.getUserRoles(withUserId: AmityUIKitManagerInternal.shared.currentUserId, role: .communityModerator)
        delegate?.screenViewModelShouldShowAddButtonBarItem(status: isModerator)
    }
}
