//
//  AppManager.swift
//  SampleApp
//
//  Created by Nontapat Siengsanor on 21/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UpstraUIKit
import EkoChat
import UIKit

class AppManager: NSObject {
    
    static let shared = AppManager()
    private override init() {}
    
    private enum UserDefaultsKey {
        static let userId = "userId"
        static let userIds = "userIds"
        static let deviceToken = "deviceToken"
    }
    
    private var isUserRegistered: Bool {
        return UserDefaults.standard.value(forKey: UserDefaultsKey.userId) != nil
    }
    
    // MARK: - AmityUIKit setup
    
    func setupAmityUIKit() {
        // setup api key
        UpstraUIKitManager.setup("API_KEY")
        
        // override clientErrorDelegate
        UpstraUIKitManager.client.clientErrorDelegate = self
        
        // setup event handlers and page settings
        UpstraUIKitManager.set(eventHandler: CustomEventHandler())
        UpstraUIKitManager.feedUISettings.eventHandler = CustomFeedEventHandler()
        UpstraUIKitManager.feedUISettings.setPostSharingSettings(settings: EkoPostSharingSettings())
        
        // setup default theme
        if let preset = Preset(rawValue: UserDefaults.standard.theme ?? 0) {
            UpstraUIKitManager.set(theme: preset.theme)
        }
        
        // if user has logged in previosly, register the user automatically.
        if let currentUserId = UserDefaults.standard.value(forKey: UserDefaultsKey.userId) as? String {
            register(withUserId: currentUserId)
        }
    }
    
    func register(withUserId userId: String) {
        UpstraUIKitManager.registerDevice(withUserId: userId, displayName: userId.uppercased()) { (success, error) in
            if success {
                print("-> register device success with user \(UpstraUIKitManager.client)")
                
            } else {
                print("-> register device failed with error \(error?.localizedDescription ?? "-")")
            }
        }
        UserDefaults.standard.setValue(userId, forKey: UserDefaultsKey.userId)
        
        UIApplication.shared.windows.first?.rootViewController = TabbarViewController()
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
        if let deviceToken = UserDefaults.standard.value(forKey: UserDefaultsKey.deviceToken) as? String {
            UpstraUIKitManager.unregisterDevicePushNotification()
            UpstraUIKitManager.registerDeviceForPushNotification(deviceToken)
        }
    }
    
    func unregister() {
        UpstraUIKitManager.unregisterDevicePushNotification()
        UpstraUIKitManager.unregisterDevice()
        UserDefaults.standard.setValue(nil, forKey: UserDefaultsKey.userId)
        
        UIApplication.shared.windows.first?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController")
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func registerDeviceToken(_ token: Data) {
        // Revoke old device token
        UpstraUIKitManager.unregisterDevicePushNotification()
        
        // Transform deviceToken into a raw string, before sending to AmitySDK server.
        let tokenParts: [String] = token.map { data in String(format: "%02.2hhx", data) }
        let tokenString: String = tokenParts.joined()
        
        UserDefaults.standard.setValue(tokenString, forKey: UserDefaultsKey.deviceToken)
        UpstraUIKitManager.registerDeviceForPushNotification(tokenString)
    }
    
    // MARK: - Login user list
    
    func getUsers() -> [String] {
        return UserDefaults.standard.value(forKey: UserDefaultsKey.userIds) as? [String] ?? []
    }
    
    func updateUsers(withUserIds userIds: [String]) {
        UserDefaults.standard.set(userIds, forKey: UserDefaultsKey.userIds)
    }
    
    // MARK: - Helpers
    
    func startingPage() -> UIViewController {
        if isUserRegistered {
            return TabbarViewController()
        } else {
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController")
        }
    }
    
}

extension AppManager: EkoClientErrorDelegate {
    
    func didReceiveAsyncError(_ error: Error) {
        print("-> error \(error)")
    }
    
}
