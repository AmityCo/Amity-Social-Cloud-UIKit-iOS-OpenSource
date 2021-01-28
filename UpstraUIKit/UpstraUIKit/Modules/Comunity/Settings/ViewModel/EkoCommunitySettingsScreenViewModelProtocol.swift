//
//  EkoCommunitySettingsScreenViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 1/8/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

protocol EkoCommunitySettingsScreenViewModelDelegate: class {
    func screenViewModel(_ viewModel: EkoCommunitySettingsScreenViewModel, didGetCommunitySuccess community: EkoCommunityModel)
    func screenViewModel(_ viewModel: EkoCommunitySettingsScreenViewModel, didLeaveCommunitySuccess: Bool)
    func screenViewModel(_ viewModel: EkoCommunitySettingsScreenViewModel, didDeleteCommunitySuccess: Bool)
    func screenViewModel(_ viewModel: EkoCommunitySettingsScreenViewModel, failure error: EkoError)
}

protocol EkoCommunitySettingsScreenViewModelDataSource {
    var community: EkoCommunityModel { get }
    var isModerator: Bool { get }
}

protocol EkoCommunitySettingsScreenViewModelAction {
    func getUserRoles()
    func leaveCommunity()
    func deleteCommunity()
}

protocol EkoCommunitySettingsScreenViewModelType: EkoCommunitySettingsScreenViewModelAction, EkoCommunitySettingsScreenViewModelDataSource {
    var delegate: EkoCommunitySettingsScreenViewModelDelegate? { get set }
    var action: EkoCommunitySettingsScreenViewModelAction { get }
    var dataSource: EkoCommunitySettingsScreenViewModelDataSource { get }
}

extension EkoCommunitySettingsScreenViewModelType {
    var action: EkoCommunitySettingsScreenViewModelAction { return self }
    var dataSource: EkoCommunitySettingsScreenViewModelDataSource { return self }
}
