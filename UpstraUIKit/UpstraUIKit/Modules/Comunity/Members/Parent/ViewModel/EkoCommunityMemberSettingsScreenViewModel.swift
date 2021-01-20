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
    private let communityInfoController: EkoCommunityInfoControllerProtocol
    
    // MARK: - Properties
    var communityId: String = ""
    var isModerator: Bool = false
    var isCreator: Bool = false
    var shouldShowAddMemberButton: Bool = false
    
    // MARK: - initial
    init(communityId: String,
         userRolesController: EkoCommunityUserRolesControllerProtocol,
         communityInfoController: EkoCommunityInfoControllerProtocol) {
        self.communityId = communityId
        self.userRolesController = userRolesController
        self.communityInfoController = communityInfoController
    }
}

// MARK: - DataSource
extension EkoCommunityMemberSettingsScreenViewModel {
    
}

// MARK: - Action
extension EkoCommunityMemberSettingsScreenViewModel {
    func getCommunity() {
        communityInfoController.getCommunity { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let community):
                self?.isCreator = community.isCreator
                self?.delegate?.screenViewModelDidGetCommmunity(strongSelf)
            case .failure(let error):
                break
            }
        }
    }
    
    func getUserRoles() {
        isModerator = userRolesController.getUserRoles(withUserId: UpstraUIKitManagerInternal.shared.currentUserId, role: .moderator)
        delegate?.screenViewModelShouldShowAddButtonBarItem(status: isCreator || isModerator)
    }
}
