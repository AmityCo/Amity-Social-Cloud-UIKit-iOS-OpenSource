//
//  AmityPostReviewSettingsScreenViewModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 11/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

final class AmityPostReviewSettingsScreenViewModel: AmityPostReviewSettingsScreenViewModelType {
    weak var delegate: AmityPostReviewSettingsScreenViewModelDelegate?
}

// MARK: - DataSource
extension AmityPostReviewSettingsScreenViewModel {
    
}

// MARK: - Action
extension AmityPostReviewSettingsScreenViewModel {
    func retrieveMenu() {
        var settingsItems = [AmitySettingsItem]()
        let approveMemberPostContent = AmitySettingsItem.ToggleContent(identifier: AmityPostReviewSettingsItem.approveMemberPost.identifier,
                                                                     iconContent: AmitySettingContentIcon(icon: AmityPostReviewSettingsItem.approveMemberPost.icon),
                                                                     title: AmityPostReviewSettingsItem.approveMemberPost.title,
                                                                     description: AmityPostReviewSettingsItem.approveMemberPost.description,
                                                                     isToggled: false)
        settingsItems.append(.toggleContent(content: approveMemberPostContent))
        settingsItems.append(.separator)
        delegate?.screenViewModel(self, didFinishWithAction: .retrieveMenu(settingItem: settingsItems))
    }
    
    func turnOnApproveMemberPost(content: AmitySettingsItem.ToggleContent) {
        delegate?.screenViewModel(self, didFinishWithAction: .turnOnApproveMemberPost(content: content))
    }
    
    func turnOffApproveMemberPost(content: AmitySettingsItem.ToggleContent) {
        delegate?.screenViewModel(self, didFinishWithAction: .turnOffApproveMemberPost(content: content))
    }
}
