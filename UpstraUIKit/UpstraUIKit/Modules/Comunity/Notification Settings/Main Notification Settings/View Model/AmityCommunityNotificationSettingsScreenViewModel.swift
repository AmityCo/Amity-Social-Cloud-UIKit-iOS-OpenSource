//
//  AmityCommunityNotificationSettingsViewModel.swift
//  AmityUIKit
//
//  Created by Hamlet on 03.03.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import AmitySDK
import UIKit

final class AmityCommunityNotificationSettingsScreenViewModel: AmityCommunityNotificationSettingsScreenViewModelType {
    
    weak var delegate: AmityCommunityNotificationSettingsViewModelDelegate?
    
    // MARK: - Controller
    private let userNotificationController = AmityUserNotificationSettingsController()
    private let notificationSettingsController: AmityCommunityNotificationSettingsControllerProtocol
    
    // MARK: - Properties
    private(set) var community: AmityCommunityModel
    private(set) var isNotificationEnabled: Bool = false
    private var settingsItems: [AmitySettingsItem] = []
    
    init(community: AmityCommunityModel, notificationSettingsController: AmityCommunityNotificationSettingsControllerProtocol) {
        self.community = community
        self.notificationSettingsController = notificationSettingsController
    }
    
    private func prepareSettingItems(notification: AmityCommunityNotificationSettings) {
        var items: [AmitySettingsItem] = []
        
        let global = AmitySettingsItem.ToggleContent(
            identifier: AmityCommunityNotificationSettingsItem.mainToggle.identifier,
            iconContent: nil,
            title: AmityCommunityNotificationSettingsItem.mainToggle.title,
            description: AmityCommunityNotificationSettingsItem.mainToggle.description,
            isToggled: notification.isEnabled)
        items.append(.toggleContent(content: global))
        items.append(.separator)
        
        if notification.isEnabled && notification.isPostNetworkEnabled {
            let postItem = AmitySettingsItem.NavigationContent(
                identifier: AmityCommunityNotificationSettingsItem.postNavigation.identifier,
                icon: AmityCommunityNotificationSettingsItem.postNavigation.icon,
                title: AmityCommunityNotificationSettingsItem.postNavigation.title,
                description: AmityCommunityNotificationSettingsItem.postNavigation.description)
            items.append(.navigationContent(content: postItem))
        }
        
        if notification.isEnabled && notification.isCommentNetworkEnabled {
            let commentItem = AmitySettingsItem.NavigationContent(
                identifier: AmityCommunityNotificationSettingsItem.commentNavigation.identifier,
                icon: AmityCommunityNotificationSettingsItem.commentNavigation.icon,
                title: AmityCommunityNotificationSettingsItem.commentNavigation.title,
                description: AmityCommunityNotificationSettingsItem.commentNavigation.description)
            items.append(.navigationContent(content: commentItem))
        }
        
        settingsItems = items
        delegate?.screenViewModel(self, didUpdateSettingItem: settingsItems)
    }
}

// MARK: - Delegate
extension AmityCommunityNotificationSettingsScreenViewModel {
    
    func enableNotificationSetting() {
        notificationSettingsController.enableNotificationSettings(events: nil) { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            if success {
                strongSelf.retrieveNotifcationSettings()
            } else {
                strongSelf.delegate?.screenViewModel(strongSelf, didFailWithError: AmityError(error: error) ?? .unknown)
            }
        }
    }
    
    func disableNotificationSetting() {
        notificationSettingsController.disableNotificationSettings { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            if success {
                self?.retrieveNotifcationSettings()
            } else {
                strongSelf.delegate?.screenViewModel(strongSelf, didFailWithError: AmityError(error: error) ?? .unknown)
            }
        }
    }
    
    func retrieveNotifcationSettings() {
        notificationSettingsController.retrieveNotificationSettings { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let notification):
                strongSelf.isNotificationEnabled = notification.isEnabled
                strongSelf.prepareSettingItems(notification: notification)
            case .failure:
                break
            }
        }
    }
    
}
