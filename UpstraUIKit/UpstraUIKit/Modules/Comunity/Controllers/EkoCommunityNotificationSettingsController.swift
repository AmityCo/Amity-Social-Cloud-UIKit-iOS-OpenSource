//
//  EkoCommunityNotificationSettingsController.swift
//  UpstraUIKit
//
//  Created by Hamlet on 05.03.21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import EkoChat
import UIKit

protocol EkoUserNotificationSettingsControllerProtocol {
    func retrieveNotificationSettings(completion: ((Result<EkoUserNotification, Error>) -> Void)?)
    func enableNotificationSettings(modules: [EkoUserNotificationModule]?)
    func disableNotificationSettings()
}

class EkoUserNotificationSettingsController: EkoUserNotificationSettingsControllerProtocol {
    
    private let notificationManager = UpstraUIKitManagerInternal.shared.client.notificationManager
    
    func retrieveNotificationSettings(completion: ((Result<EkoUserNotification, Error>) -> Void)?) {
        notificationManager.getSettingsWithCompletion { (notification, error) in
            if let notification = notification {
                completion?(.success(notification))
            } else {
                completion?(.failure(error ?? EkoError.unknown))
            }
        }
    }
    
    func enableNotificationSettings(modules: [EkoUserNotificationModule]?) {
        notificationManager.enableSetting(with: modules, completion: nil)
    }
    
    func disableNotificationSettings() {
        notificationManager.disableSetting(completion: nil)
    }
    
}

protocol EkoCommunityNotificationSettingsControllerProtocol {
    func retrieveNotificationSettings(completion: ((Result<EkoCommunityNotification, Error>) -> Void)?)
    func enableNotificationSettings(events: [EkoCommunityNotificationEvent]?, completion: EkoRequestCompletion?)
    func disableNotificationSettings(completion: EkoRequestCompletion?)
}

final class EkoCommunityNotificationSettingsController: EkoCommunityNotificationSettingsControllerProtocol {
    
    private let repository: EkoCommunityRepository
    private let communityId: String
    private let notificationManager: EkoCommunityNotificationsManager
    
    init(withCommunityId _communityId: String) {
        communityId = _communityId
        repository = EkoCommunityRepository(client: UpstraUIKitManagerInternal.shared.client)
        notificationManager = repository.notificationManager(forCommunityId: communityId)
    }
    
    func retrieveNotificationSettings(completion: ((Result<EkoCommunityNotification, Error>) -> Void)?) {
        notificationManager.getPushNotificationSetting { (notification, error) in
            if let notification = notification {
                completion?(.success(notification))
            } else {
                completion?(.failure(error ?? EkoError.unknown))
            }
        }
    }
    
    func enableNotificationSettings(events: [EkoCommunityNotificationEvent]?, completion: EkoRequestCompletion?) {
        notificationManager.enableSetting(with: events, completion: completion)
    }
    
    func disableNotificationSettings(completion: EkoRequestCompletion?) {
        notificationManager.disableSetting(completion: completion)
    }
    
}
