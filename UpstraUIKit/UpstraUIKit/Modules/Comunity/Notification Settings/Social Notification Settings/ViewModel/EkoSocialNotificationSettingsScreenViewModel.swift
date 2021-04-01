//
//  EkoPostNotificationSettingsScreenViewModel.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 24/3/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import EkoChat

class EkoSocialNotificationSettingsScreenViewModel: EkoPostNotificationSettingsScreenViewModelType {
    
    weak var delegate: EkoSocialNotificationSettingsScreenViewModelDelgate?
    
    // MARK: - Data Source
    let type: EkoCommunityNotificationSettingsType
    private(set) var settingItems: [EkoSettingsItem] = []
    
    var isValueChanged: Bool {
        return supportedEvents
            .map { eventSettingMap[$0] != originalEventSettingMap[$0] }
            .reduce(false, { $0 || $1 })
    }
    
    // MARK: - Properties
    private let userNotificationController: EkoUserNotificationSettingsControllerProtocol
    private let communityNotificationController: EkoCommunityNotificationSettingsControllerProtocol
    
    // MARK: - Setting Properties
    private var isUserEnabled = false
    private var isUserListeningFromModerator = false
    private var notification: EkoCommunityNotification?
    private var eventSettingMap = [CommunityNotificationEventType: CommunityNotificationSettingModel]()
    private var originalEventSettingMap = [CommunityNotificationEventType: CommunityNotificationSettingModel]()
    
    private var supportedEvents: [CommunityNotificationEventType] {
        switch type {
        case .comment:
            return [.commentReacted, .commentCreated, .commentReplied]
        case .post:
            return  [.postReacted, .postCreated]
        }
    }
    
    init(userNotificationController: EkoUserNotificationSettingsControllerProtocol,
        communityNotificationController: EkoCommunityNotificationSettingsControllerProtocol,
        type: EkoCommunityNotificationSettingsType) {
        self.userNotificationController = userNotificationController
        self.communityNotificationController = communityNotificationController
        self.type = type
    }
    
    func retrieveNotifcationSettings() {
        userNotificationController.retrieveNotificationSettings { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let notification):
                guard let social = notification.modules.first(where: { $0.moduleType == .social }) else { break }
                strongSelf.isUserListeningFromModerator = notification.isSocialListeningToModerator
                strongSelf.isUserEnabled = social.isEnabled
                strongSelf.setupNotificationSetting()
            case .failure:
                break
            }
        }
        communityNotificationController.retrieveNotificationSettings { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let notification):
                strongSelf.notification = notification
                strongSelf.setupNotificationSetting()
            break
            case .failure:
                break
            }
        }
    }
    
    func saveNotificationSettings() {
        var events: [EkoCommunityNotificationEvent] = []
        
        for event in supportedEvents {
            if let setting = eventSettingMap[event],
               let originalSetting = originalEventSettingMap[event],
               setting != originalSetting {
                
                var roleFilter: EkoRoleFilter?
                var isEnabled = false
                switch setting.selectedOption {
                case .everyOne:
                    roleFilter = EkoRoleFilter.all()
                    isEnabled = true
                case .onlyModerator:
                    roleFilter = EkoRoleFilter.onlyFilter(withRoleIds: [EkoCommunityRole.moderator.rawValue])
                    isEnabled = true
                case .off:
                    roleFilter = nil
                    isEnabled = false
                }
                events.append(EkoCommunityNotificationEvent(eventType: event.eventType, isEnabled: isEnabled, roleFilter: roleFilter))
            }
        }
        
        communityNotificationController.enableNotificationSettings(events: events) { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            if success {
                // if success, update original value
                strongSelf.originalEventSettingMap = strongSelf.eventSettingMap
                strongSelf.delegate?.screenViewModelDidUpdateSettingSuccess(strongSelf)
            } else {
                // if error, revert data changes to original
                strongSelf.eventSettingMap = strongSelf.originalEventSettingMap
                strongSelf.delegate?.screenViewModel(strongSelf, didUpdateSettingFailWithError: EkoError(error: error) ?? .unknown)
            }
            strongSelf.prepareSettingItems()
        }
    }
    
    func updateSetting(setting: CommunityNotificationEventType, option: NotificationSettingOptionType) {
        eventSettingMap[setting]?.selectedOption = option
        prepareSettingItems()
    }
    
    // MARK: - Helper Methods
    
    private func setupNotificationSetting() {
        guard let notification = notification else { return }
        for event in notification.events {
            if let communityEvent = CommunityNotificationEventType(eventType: event.eventType), supportedEvents.contains(communityEvent) {
                eventSettingMap[communityEvent] = CommunityNotificationSettingModel(event: event, isUserListeningFromModerator: isUserListeningFromModerator)
            }
        }
        originalEventSettingMap = eventSettingMap
        prepareSettingItems()
    }
    
    private func prepareMenu() -> [EkoSettingsItem] {
        var communitySettingItems: [CommunityNotificationSettingItem] = []
        for index in 0..<supportedEvents.count {
            let type = supportedEvents[index]
            // put separator if there is more than 1 setting section
            if index > 0 {
                communitySettingItems.append(CommunityNotificationSettingItem(event: type, menu: .separator))
            }
            
            communitySettingItems.append(CommunityNotificationSettingItem(event: type, menu: .description))
            if !isUserListeningFromModerator {
                communitySettingItems.append(CommunityNotificationSettingItem(event: type, menu: .option(.everyOne)))
            }
            communitySettingItems.append(CommunityNotificationSettingItem(event: type, menu: .option(.onlyModerator)))
            communitySettingItems.append(CommunityNotificationSettingItem(event: type, menu: .option(.off)))
        }
        
        var items: [EkoSettingsItem] = []
        for settingItem in communitySettingItems {
            // if setting is enabled from admin panel, show the settings.
            guard let setting = eventSettingMap[settingItem.event], setting.isNetworkEnabled else { continue }
            
            switch settingItem.menu {
            case .description:
                let descContent = EkoSettingsItem.TextContent(
                    identifier: settingItem.identifier,
                    icon: nil,
                    title: settingItem.event.title,
                    description: settingItem.event.description)
                items.append(.textContent(content: descContent))
            case .option(let option):
                switch option {
                case .everyOne:
                    let everyoneOption = EkoSettingsItem.RadionButtonContent(
                        identifier: settingItem.identifier,
                        title: EkoLocalizedStringSet.CommunityNotificationSettings.everyone.localizedString,
                        isSelected: setting.selectedOption == .everyOne)
                    items.append(.radioButtonContent(content: everyoneOption))
                case .onlyModerator:
                    let onlyModratorOption = EkoSettingsItem.RadionButtonContent(
                        identifier: settingItem.identifier,
                        title: EkoLocalizedStringSet.CommunityNotificationSettings.onlyModerator.localizedString,
                        isSelected: setting.selectedOption == .onlyModerator)
                    items.append(.radioButtonContent(content: onlyModratorOption))
                case .off :
                    let offOption = EkoSettingsItem.RadionButtonContent(
                        identifier: settingItem.identifier,
                        title: EkoLocalizedStringSet.off.localizedString,
                        isSelected: setting.selectedOption == .off)
                    items.append(.radioButtonContent(content: offOption))
                }
                
            case .separator:
                items.append(.separator)
            }
        }
        return items
    }
    
    private func prepareSettingItems() {
        settingItems = prepareMenu()
        delegate?.screenViewModel(self, didReceiveSettingItems: settingItems)
    }
    
}
