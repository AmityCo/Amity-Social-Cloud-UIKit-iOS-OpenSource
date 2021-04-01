//
//  EkoCommunitySettingsScreenViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 10/3/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import UIKit

protocol EkoCommunitySettingsScreenViewModelDelegate: class {
    func screenViewModel(_ viewModel: EkoCommunitySettingsScreenViewModelType, didGetSettingMenu settings: [EkoSettingsItem])
    func screenViewModel(_ viewModel: EkoCommunitySettingsScreenViewModelType, didGetCommunitySuccess community: EkoCommunityModel)
    func screenViewModelDidLeaveCommunity()
    func screenViewModelDidCloseCommunity()
    func screenViewModelDidLeaveCommunityFail()
    func screenViewModelDidCloseCommunityFail()
    func screenViewModel(_ viewModel: EkoCommunitySettingsScreenViewModelType, failure error: EkoError)
}

protocol EkoCommunitySettingsScreenViewModelDataSource {
    var community: EkoCommunityModel { get }
}

protocol EkoCommunitySettingsScreenViewModelAction {
    func retrieveSettingsMenu()
    func retrieveCommunity()
    func retrieveNotifcationSettings()
    func leaveCommunity()
    func closeCommunity()
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
