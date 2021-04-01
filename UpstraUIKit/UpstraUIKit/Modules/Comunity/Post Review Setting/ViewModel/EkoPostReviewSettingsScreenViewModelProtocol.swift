//
//  EkoPostReviewSettingsScreenViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 11/3/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import UIKit

enum EkoPostReviewSettingsAction {
    case retrieveMenu(settingItem: [EkoSettingsItem])
    case turnOnApproveMemberPost(content: EkoSettingsItem.ToggleContent)
    case turnOffApproveMemberPost(content: EkoSettingsItem.ToggleContent)
}


protocol EkoPostReviewSettingsScreenViewModelDelegate: class {
    func screenViewModel(_ viewModel: EkoPostReviewSettingsScreenViewModelType, didFinishWithAction action: EkoPostReviewSettingsAction)
    func screenViewModel(_ viewModel: EkoPostReviewSettingsScreenViewModelType, didFailWithAction action: EkoPostReviewSettingsAction)
    func screenViewModel(_ viewModel: EkoPostReviewSettingsScreenViewModelType, didFailWithError error: EkoError)
}

protocol EkoPostReviewSettingsScreenViewModelDataSource {
    
}

protocol EkoPostReviewSettingsScreenViewModelAction {
    func retrieveMenu()
    func turnOffApproveMemberPost(content: EkoSettingsItem.ToggleContent)
    func turnOnApproveMemberPost(content: EkoSettingsItem.ToggleContent)
}

protocol EkoPostReviewSettingsScreenViewModelType: EkoPostReviewSettingsScreenViewModelAction, EkoPostReviewSettingsScreenViewModelDataSource {
    var delegate: EkoPostReviewSettingsScreenViewModelDelegate? { get set }
    var action: EkoPostReviewSettingsScreenViewModelAction { get }
    var dataSource: EkoPostReviewSettingsScreenViewModelDataSource { get }
}

extension EkoPostReviewSettingsScreenViewModelType {
    var action: EkoPostReviewSettingsScreenViewModelAction { return self }
    var dataSource: EkoPostReviewSettingsScreenViewModelDataSource { return self }
}
