//
//  AmityPostNotificationSettingsScreenViewModelType.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 22/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import AmitySDK

enum AmityCommunityNotificationSettingsType {
    case post
    case comment
}

protocol AmitySocialNotificationSettingsScreenViewModelDelgate: AnyObject {
    func screenViewModel(_ viewModel: AmitySocialNotificationSettingsScreenViewModel, didReceiveSettingItems items: [AmitySettingsItem])
    func screenViewModelDidUpdateSettingSuccess(_ viewModel: AmitySocialNotificationSettingsScreenViewModel)
    func screenViewModel(_ viewModel: AmitySocialNotificationSettingsScreenViewModel, didUpdateSettingFailWithError error: AmityError)
}

protocol AmityPostNotificationSettingsScreenViewModelAction {
    func retrieveNotifcationSettings()
    func saveNotificationSettings()
    func updateSetting(setting: CommunityNotificationEventType, option: NotificationSettingOptionType)
}

protocol AmityPostNotificationSettingsScreenViewModelDataSource {
    var type: AmityCommunityNotificationSettingsType { get }
    var settingItems: [AmitySettingsItem] { get }
    var isValueChanged: Bool { get }
}

protocol AmityPostNotificationSettingsScreenViewModelType: AmityPostNotificationSettingsScreenViewModelAction, AmityPostNotificationSettingsScreenViewModelDataSource {
    var delegate: AmitySocialNotificationSettingsScreenViewModelDelgate? { get set }
    var action: AmityPostNotificationSettingsScreenViewModelAction { get }
    var dataSource: AmityPostNotificationSettingsScreenViewModelDataSource { get }
}

extension AmityPostNotificationSettingsScreenViewModelType {
    var action: AmityPostNotificationSettingsScreenViewModelAction { return self }
    var dataSource: AmityPostNotificationSettingsScreenViewModelDataSource { return self }
}
