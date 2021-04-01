//
//  EkoCommunityNotificationSettingsViewModel.swift
//  UpstraUIKit
//
//  Created by Hamlet on 03.03.21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import EkoChat
import UIKit

final class EkoCommunityNotificationSettingsScreenViewModel: EkoCommunityNotificationSettingsScreenViewModelType {
    
    weak var delegate: EkoCommunityNotificationSettingsViewModelDelegate?
    
    // MARK: - Controller
    private let userNotificationController = EkoUserNotificationSettingsController()
    private let notificationSettingsController: EkoCommunityNotificationSettingsControllerProtocol
    
    // MARK: - Properties
    private(set) var community: EkoCommunityModel
    private(set) var isNotificationEnabled: Bool = false
    private var settingsItems: [EkoSettingsItem] = []
    
    init(community: EkoCommunityModel, notificationSettingsController: EkoCommunityNotificationSettingsControllerProtocol) {
        self.community = community
        self.notificationSettingsController = notificationSettingsController
    }
    
    private func prepareSettingItems(notification: EkoCommunityNotification) {
        var items: [EkoSettingsItem] = []
        
        let global = EkoSettingsItem.ToggleContent(
            identifier: EkoCommunityNotificationSettingsItem.mainToggle.identifier,
            iconContent: nil,
            title: EkoCommunityNotificationSettingsItem.mainToggle.title,
            description: EkoCommunityNotificationSettingsItem.mainToggle.description,
            isToggled: notification.isEnabled)
        items.append(.toggleContent(content: global))
        items.append(.separator)
        
        if notification.isEnabled && notification.isPostNetworkEnabled {
            let postItem = EkoSettingsItem.NavigationContent(
                identifier: EkoCommunityNotificationSettingsItem.postNavigation.identifier,
                icon: EkoCommunityNotificationSettingsItem.postNavigation.icon,
                title: EkoCommunityNotificationSettingsItem.postNavigation.title,
                description: EkoCommunityNotificationSettingsItem.postNavigation.description)
            items.append(.navigationContent(content: postItem))
        }
        
        if notification.isEnabled && notification.isCommentNetworkEnabled {
            let commentItem = EkoSettingsItem.NavigationContent(
                identifier: EkoCommunityNotificationSettingsItem.commentNavigation.identifier,
                icon: EkoCommunityNotificationSettingsItem.commentNavigation.icon,
                title: EkoCommunityNotificationSettingsItem.commentNavigation.title,
                description: EkoCommunityNotificationSettingsItem.commentNavigation.description)
            items.append(.navigationContent(content: commentItem))
        }
        
        settingsItems = items
        delegate?.screenViewModel(self, didUpdateSettingItem: settingsItems)
    }
}

// MARK: - Delegate
extension EkoCommunityNotificationSettingsScreenViewModel {
    
    func enableNotificationSetting() {
        notificationSettingsController.enableNotificationSettings(events: nil) { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            if success {
                strongSelf.retrieveNotifcationSettings()
            } else {
                strongSelf.delegate?.screenViewModel(strongSelf, didFailWithError: EkoError(error: error) ?? .unknown)
            }
        }
    }
    
    func disableNotificationSetting() {
        notificationSettingsController.disableNotificationSettings { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            if success {
                self?.retrieveNotifcationSettings()
            } else {
                strongSelf.delegate?.screenViewModel(strongSelf, didFailWithError: EkoError(error: error) ?? .unknown)
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
