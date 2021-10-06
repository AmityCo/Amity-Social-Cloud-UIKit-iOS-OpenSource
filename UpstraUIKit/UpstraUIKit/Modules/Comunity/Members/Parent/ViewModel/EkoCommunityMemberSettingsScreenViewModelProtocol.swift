//
//  EkoCommunityMemberSettingsScreenViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 1/11/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

protocol EkoCommunityMemberSettingsScreenViewModelDelegate: class {
    func screenViewModelShouldShowAddButtonBarItem(status: Bool)
}

protocol EkoCommunityMemberSettingsScreenViewModelDataSource {
    var community: EkoCommunityModel { get }
    var shouldShowAddMemberButton: Bool { get }
}

protocol EkoCommunityMemberSettingsScreenViewModelAction {
    func getUserPermission()
}

protocol EkoCommunityMemberSettingsScreenViewModelType: EkoCommunityMemberSettingsScreenViewModelAction, EkoCommunityMemberSettingsScreenViewModelDataSource {
    var delegate: EkoCommunityMemberSettingsScreenViewModelDelegate? { get set }
    var action: EkoCommunityMemberSettingsScreenViewModelAction { get }
    var dataSource: EkoCommunityMemberSettingsScreenViewModelDataSource { get }
}

extension EkoCommunityMemberSettingsScreenViewModelType {
    var action: EkoCommunityMemberSettingsScreenViewModelAction { return self }
    var dataSource: EkoCommunityMemberSettingsScreenViewModelDataSource { return self }
}
