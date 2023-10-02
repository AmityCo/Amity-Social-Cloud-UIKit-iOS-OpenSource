//
//  AmityCommunityNotificationSettingsViewModelProtocol.swift
//  AmityUIKit
//
//  Created by Hamlet on 03.03.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

enum AmityCommunityNotificationSettingsItem: String {
    case mainToggle
    case postNavigation
    case commentNavigation
    
    var identifier: String {
        return self.rawValue
    }
    
    var title: String {
        switch self {
        case .mainToggle:
            return AmityLocalizedStringSet.CommunityNotificationSettings.titleNotifications.localizedString
        case .postNavigation:
            return AmityLocalizedStringSet.CommunityNotificationSettings.post.localizedString
        case .commentNavigation:
            return AmityLocalizedStringSet.CommunityNotificationSettings.comment.localizedString
        }
    }
    
    var description: String? {
        switch self {
        case .mainToggle:
            return AmityLocalizedStringSet.CommunityNotificationSettings.descriptionNotifications.localizedString
        case .postNavigation:
            return nil
        case .commentNavigation:
            return nil
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .mainToggle:
            return AmityIconSet.CommunityNotificationSettings.iconNotificationSettings
        case .postNavigation:
            return AmityIconSet.CommunitySettings.iconPostSetting
        case .commentNavigation:
            return AmityIconSet.CommunitySettings.iconCommentSetting
        }
    }
    
}

protocol AmityCommunityNotificationSettingsViewModelDelegate: AnyObject {
    func screenViewModel(_ viewModel: AmityCommunityNotificationSettingsScreenViewModelType, didUpdateSettingItem settings: [AmitySettingsItem])
    func screenViewModel(_ viewModel: AmityCommunityNotificationSettingsScreenViewModelType, didUpdateLoadingState state: AmityLoadingState)
    func screenViewModel(_ viewModel: AmityCommunityNotificationSettingsScreenViewModelType, didFailWithError error: AmityError)
}

protocol AmityCommunityNotificationSettingsViewModelDataSource {
    var community: AmityCommunityModel { get }
    var isNotificationEnabled: Bool { get }
}

protocol AmityCommunityNotificationSettingsViewModelAction {
    func retrieveNotifcationSettings()
    func enableNotificationSetting()
    func disableNotificationSetting()
}

protocol AmityCommunityNotificationSettingsScreenViewModelType: AmityCommunityNotificationSettingsViewModelAction, AmityCommunityNotificationSettingsViewModelDataSource {
    var delegate: AmityCommunityNotificationSettingsViewModelDelegate? { get set }
    var action: AmityCommunityNotificationSettingsViewModelAction { get }
    var dataSource: AmityCommunityNotificationSettingsViewModelDataSource { get }
}

extension AmityCommunityNotificationSettingsScreenViewModelType {
    var action: AmityCommunityNotificationSettingsViewModelAction { return self }
    var dataSource: AmityCommunityNotificationSettingsViewModelDataSource { return self }
}
