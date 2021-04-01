//
//  EkoCommunityNotificationSettingsViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by Hamlet on 03.03.21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

enum EkoCommunityNotificationSettingsItem: String {
    case mainToggle
    case postNavigation
    case commentNavigation
    
    var identifier: String {
        return self.rawValue
    }
    
    var title: String {
        switch self {
        case .mainToggle:
            return EkoLocalizedStringSet.CommunityNotificationSettings.titleNotifications.localizedString
        case .postNavigation:
            return EkoLocalizedStringSet.CommunityNotificationSettings.post.localizedString
        case .commentNavigation:
            return EkoLocalizedStringSet.CommunityNotificationSettings.comment.localizedString
        }
    }
    
    var description: String? {
        switch self {
        case .mainToggle:
            return EkoLocalizedStringSet.CommunityNotificationSettings.descriptionNotifications.localizedString
        case .postNavigation:
            return nil
        case .commentNavigation:
            return nil
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .mainToggle:
            return EkoIconSet.CommunityNotificationSettings.iconNotificationSettings
        case .postNavigation:
            return EkoIconSet.CommunitySettings.iconPostSetting
        case .commentNavigation:
            return EkoIconSet.CommunitySettings.iconCommentSetting
        }
    }
    
}

protocol EkoCommunityNotificationSettingsViewModelDelegate: class {
    func screenViewModel(_ viewModel: EkoCommunityNotificationSettingsScreenViewModelType, didUpdateSettingItem settings: [EkoSettingsItem])
    func screenViewModel(_ viewModel: EkoCommunityNotificationSettingsScreenViewModelType, didUpdateLoadingState state: EkoLoadingState)
    func screenViewModel(_ viewModel: EkoCommunityNotificationSettingsScreenViewModelType, didFailWithError error: EkoError)
}

protocol EkoCommunityNotificationSettingsViewModelDataSource {
    var community: EkoCommunityModel { get }
    var isNotificationEnabled: Bool { get }
}

protocol EkoCommunityNotificationSettingsViewModelAction {
    func retrieveNotifcationSettings()
    func enableNotificationSetting()
    func disableNotificationSetting()
}

protocol EkoCommunityNotificationSettingsScreenViewModelType: EkoCommunityNotificationSettingsViewModelAction, EkoCommunityNotificationSettingsViewModelDataSource {
    var delegate: EkoCommunityNotificationSettingsViewModelDelegate? { get set }
    var action: EkoCommunityNotificationSettingsViewModelAction { get }
    var dataSource: EkoCommunityNotificationSettingsViewModelDataSource { get }
}

extension EkoCommunityNotificationSettingsScreenViewModelType {
    var action: EkoCommunityNotificationSettingsViewModelAction { return self }
    var dataSource: EkoCommunityNotificationSettingsViewModelDataSource { return self }
}
