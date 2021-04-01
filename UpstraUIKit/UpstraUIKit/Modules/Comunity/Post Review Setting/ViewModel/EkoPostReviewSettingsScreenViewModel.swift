//
//  EkoPostReviewSettingsScreenViewModel.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 11/3/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import UIKit

final class EkoPostReviewSettingsScreenViewModel: EkoPostReviewSettingsScreenViewModelType {
    weak var delegate: EkoPostReviewSettingsScreenViewModelDelegate?
}

// MARK: - DataSource
extension EkoPostReviewSettingsScreenViewModel {
    
}

// MARK: - Action
extension EkoPostReviewSettingsScreenViewModel {
    func retrieveMenu() {
        var settingsItems = [EkoSettingsItem]()
        let approveMemberPostContent = EkoSettingsItem.ToggleContent(identifier: EkoPostReviewSettingsItem.approveMemberPost.identifier,
                                                                     iconContent: EkoSettingContentIcon(icon: EkoPostReviewSettingsItem.approveMemberPost.icon),
                                                                     title: EkoPostReviewSettingsItem.approveMemberPost.title,
                                                                     description: EkoPostReviewSettingsItem.approveMemberPost.description,
                                                                     isToggled: false)
        settingsItems.append(.toggleContent(content: approveMemberPostContent))
        settingsItems.append(.separator)
        delegate?.screenViewModel(self, didFinishWithAction: .retrieveMenu(settingItem: settingsItems))
    }
    
    func turnOnApproveMemberPost(content: EkoSettingsItem.ToggleContent) {
        delegate?.screenViewModel(self, didFinishWithAction: .turnOnApproveMemberPost(content: content))
    }
    
    func turnOffApproveMemberPost(content: EkoSettingsItem.ToggleContent) {
        delegate?.screenViewModel(self, didFinishWithAction: .turnOffApproveMemberPost(content: content))
    }
}
