//
//  EkoCommunitySettingsScreenViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 1/8/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

protocol EkoCommunitySettingsScreenViewModelDelegate: class {
    func screenViewModelDidGetCommunitySuccess(community: EkoCommunityModel)
    func screenViewModelDidLeaveCommunitySuccess()
    func screenVieWModelDidDeleteCommunitySuccess()
    func screenViewModelFailure()
}

protocol EkoCommunitySettingsScreenViewModelDataSource {
    var communityId: String { get }
    var isCreator: Bool { get }
}

protocol EkoCommunitySettingsScreenViewModelAction {
    func getCommunity()
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
