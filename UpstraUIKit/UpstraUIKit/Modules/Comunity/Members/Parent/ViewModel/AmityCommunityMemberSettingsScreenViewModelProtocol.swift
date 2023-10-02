//
//  AmityCommunityMemberSettingsScreenViewModelProtocol.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 1/11/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

protocol AmityCommunityMemberSettingsScreenViewModelDelegate: AnyObject {
    func screenViewModelShouldShowAddButtonBarItem(status: Bool)
}

protocol AmityCommunityMemberSettingsScreenViewModelDataSource {
    var community: AmityCommunityModel { get }
    var isModerator: Bool { get }
    var shouldShowAddMemberButton: Bool { get }
}

protocol AmityCommunityMemberSettingsScreenViewModelAction {
    func getUserRoles()
}

protocol AmityCommunityMemberSettingsScreenViewModelType: AmityCommunityMemberSettingsScreenViewModelAction, AmityCommunityMemberSettingsScreenViewModelDataSource {
    var delegate: AmityCommunityMemberSettingsScreenViewModelDelegate? { get set }
    var action: AmityCommunityMemberSettingsScreenViewModelAction { get }
    var dataSource: AmityCommunityMemberSettingsScreenViewModelDataSource { get }
}

extension AmityCommunityMemberSettingsScreenViewModelType {
    var action: AmityCommunityMemberSettingsScreenViewModelAction { return self }
    var dataSource: AmityCommunityMemberSettingsScreenViewModelDataSource { return self }
}
