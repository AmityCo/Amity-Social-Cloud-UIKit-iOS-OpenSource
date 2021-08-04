//
//  AmityUserSettingsScreenViewModelProtocol.swift
//  AmityUIKit
//
//  Created by Hamlet on 28.05.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityUserSettingsScreenViewModelDelegate: AnyObject {
    func screenViewModelDidUnfollowUser()
    func screenViewModelDidUnfollowUserFail()
    func screenViewModelDidFlagUserSuccess()
    func screenViewModelDidUnflagUserSuccess()
    func screenViewModel(_ viewModel: AmityUserSettingsScreenViewModelType, didGetSettingMenu settings: [AmitySettingsItem])
    func screenViewModel(_ viewModel: AmityUserSettingsScreenViewModelType, didGetUserSuccess user: AmityUserModel)
    func screenViewModel(_ viewModel: AmityUserSettingsScreenViewModelType, failure error: AmityError)
}

protocol AmityUserSettingsScreenViewModelDataSource {
    var userId: String { get }
    var user: AmityUser? { get }
}

protocol AmityUserSettingsScreenViewModelAction {
    func unfollowUser()
    func reportUser()
    func unreportUser()
    func fetchUserSettings()
}

protocol AmityUserSettingsScreenViewModelType: AmityUserSettingsScreenViewModelAction, AmityUserSettingsScreenViewModelDataSource {
    var delegate: AmityUserSettingsScreenViewModelDelegate? { get set }
    var action: AmityUserSettingsScreenViewModelAction { get }
    var dataSource: AmityUserSettingsScreenViewModelDataSource { get }
}

extension AmityUserSettingsScreenViewModelType {
    var action: AmityUserSettingsScreenViewModelAction { return self }
    var dataSource: AmityUserSettingsScreenViewModelDataSource { return self }
}
