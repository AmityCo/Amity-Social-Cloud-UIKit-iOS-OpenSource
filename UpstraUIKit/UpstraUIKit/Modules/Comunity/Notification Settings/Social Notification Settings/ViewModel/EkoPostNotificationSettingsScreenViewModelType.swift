//
//  EkoPostNotificationSettingsScreenViewModelType.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 22/3/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import EkoChat

enum EkoCommunityNotificationSettingsType {
    case post
    case comment
}

protocol EkoSocialNotificationSettingsScreenViewModelDelgate: class {
    func screenViewModel(_ viewModel: EkoSocialNotificationSettingsScreenViewModel, didReceiveSettingItems items: [EkoSettingsItem])
    func screenViewModelDidUpdateSettingSuccess(_ viewModel: EkoSocialNotificationSettingsScreenViewModel)
    func screenViewModel(_ viewModel: EkoSocialNotificationSettingsScreenViewModel, didUpdateSettingFailWithError error: EkoError)
}

protocol EkoPostNotificationSettingsScreenViewModelAction {
    func retrieveNotifcationSettings()
    func saveNotificationSettings()
    func updateSetting(setting: CommunityNotificationEventType, option: NotificationSettingOptionType)
}

protocol EkoPostNotificationSettingsScreenViewModelDataSource {
    var type: EkoCommunityNotificationSettingsType { get }
    var settingItems: [EkoSettingsItem] { get }
    var isValueChanged: Bool { get }
}

protocol EkoPostNotificationSettingsScreenViewModelType: EkoPostNotificationSettingsScreenViewModelAction, EkoPostNotificationSettingsScreenViewModelDataSource {
    var delegate: EkoSocialNotificationSettingsScreenViewModelDelgate? { get set }
    var action: EkoPostNotificationSettingsScreenViewModelAction { get }
    var dataSource: EkoPostNotificationSettingsScreenViewModelDataSource { get }
}

extension EkoPostNotificationSettingsScreenViewModelType {
    var action: EkoPostNotificationSettingsScreenViewModelAction { return self }
    var dataSource: EkoPostNotificationSettingsScreenViewModelDataSource { return self }
}
