//
//  AmityChannelMemberSettingsScreenViewModelProtocol.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 1/11/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

protocol AmityChannelMemberSettingsScreenViewModelDelegate: AnyObject {
    func screenViewModelShouldShowAddButtonBarItem(status: Bool)
}

protocol AmityChannelMemberSettingsScreenViewModelDataSource {
    var channel: AmityChannelModel { get }
    var isModerator: Bool { get }
    var shouldShowAddMemberButton: Bool { get }
}

protocol AmityChannelMemberSettingsScreenViewModelAction {
    func getUserRoles()
}

protocol AmityChannelMemberSettingsScreenViewModelType: AmityChannelMemberSettingsScreenViewModelAction, AmityChannelMemberSettingsScreenViewModelDataSource {
    var delegate: AmityChannelMemberSettingsScreenViewModelDelegate? { get set }
    var action: AmityChannelMemberSettingsScreenViewModelAction { get }
    var dataSource: AmityChannelMemberSettingsScreenViewModelDataSource { get }
}

extension AmityChannelMemberSettingsScreenViewModelType {
    var action: AmityChannelMemberSettingsScreenViewModelAction { return self }
    var dataSource: AmityChannelMemberSettingsScreenViewModelDataSource { return self }
}
