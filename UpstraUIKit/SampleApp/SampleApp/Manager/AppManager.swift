//
//  AppManager.swift
//  SampleApp
//
//  Created by Nontapat Siengsanor on 21/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import AmitySDK
import AmityUIKit
import UIKit

class AppManager {
    
    static let shared = AppManager()
    private init() {}
    
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
//        AmityUIKitManager.setup(apiKey: "b0eceb5e68ddf36545308f4e000b12dcd90985e2bf3d6a2e")
//        AmityUIKitManager.setup(apiKey: "b0ecba5c3a8af830443f8a1a515e1edbd50088e3b330667d")
        
        
        let endpointConfig = EndpointManager.shared.currentEndpointConfig
                AmityUIKitManager.setup(apiKey: endpointConfig.apiKey,
                                        httpUrl: endpointConfig.httpEndpoint,
                                        socketUrl: endpointConfig.socketEndpoint)
        
        
        // setup event handlers and page settings
        AmityUIKitManager.set(eventHandler: AmityCustomEventHandler())
        AmityUIKitManager.set(channelEventHandler: CustomChannelEventHandler())
        AmityUIKitManager.feedUISettings.eventHandler = CustomFeedEventHandler()
        AmityUIKitManager.feedUISettings.setPostSharingSettings(settings: AmityPostSharingSettings())
        
        // setup default theme
        if let preset = Preset(rawValue: UserDefaults.standard.theme ?? 0) {
            AmityUIKitManager.set(theme: preset.theme)
        }
        
        // if user has logged in previosly, register the user automatically.
        if let currentUserId = UserDefaults.standard.value(forKey: UserDefaultsKey.userId) as? String {
            register(withUserId: currentUserId)
        }
        
    }
    
    func register(withUserId userId: String) {
        
        if AmityUIKitManager.isClient {
            debugPrint("Have")
        } else {
            debugPrint("Don't Have")
        }
        
        AmityUIKitManager.registerDevice(withUserId: userId, displayName: nil) { success, error in
            print("[Sample App] register device with userId '\(userId)' \(success ? "successfully" : "failed")")
            if let error = error {
                print("[Sample App] register device failed \(error.localizedDescription)")
                self.registerDevicePushNotification()
               
            }
            self.registerDevicePushNotification()
        }
        UserDefaults.standard.setValue(userId, forKey: UserDefaultsKey.userId)
        
        UIApplication.shared.windows.first?.rootViewController = TabbarViewController()
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }
    
    private func registerDevicePushNotification() {
        
        guard let deviceToken = UserDefaults.standard.value(forKey: UserDefaultsKey.deviceToken) as? String else { return }
        
        AmityUIKitManager.registerDeviceForPushNotification(deviceToken) { success, error in
            if success {
                AmityHUD.show(.success(message: "Success with id \(deviceToken)"))
            } else {
                AmityHUD.show(.error(message: "Failed with error \(error?.localizedDescription)"))
            }
            
        }
        
    }
    
    func unregister() {
        // 1. unregister push notification
        AmityUIKitManager.unregisterDevicePushNotification() { success, error in
            if let error = error {
                AmityHUD.show(.error(message: "Unregister failed with error \(error.localizedDescription)"))
            }
            
            // 2. unregister user
            //    wether it success or failed, we execute unregister to not breaking logout flow.
            AmityUIKitManager.unregisterDevice()
            UserDefaults.standard.setValue(nil, forKey: UserDefaultsKey.deviceToken)
            UserDefaults.standard.setValue(nil, forKey: UserDefaultsKey.userId)
            
            UIApplication.shared.windows.first?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterNavigationController")
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            UIApplication.shared.applicationIconBadgeNumber = 0  // reset badge counter
        }
    }
    
    func unregisterDevicePushNotification(completion: AmityRequestCompletion?) {
        AmityUIKitManager.unregisterDevicePushNotification(completion: completion)
    }
    
    func registerDeviceToken(_ token: Data) {
        // Revoke old device token
        AmityUIKitManager.unregisterDevicePushNotification()
        
        // Transform deviceToken into a raw string, before sending to AmitySDK server.
        let tokenParts: [String] = token.map { data in String(format: "%02.2hhx", data) }
        let tokenString: String = tokenParts.joined()
        
        UserDefaults.standard.setValue(tokenString, forKey: UserDefaultsKey.deviceToken)
        AmityUIKitManager.registerDeviceForPushNotification(tokenString)
    }
    
    // MARK: - Login user list
    
    func getUsers() -> [String] {
        return UserDefaults.standard.value(forKey: UserDefaultsKey.userIds) as? [String] ?? []
    }
    
    func updateUsers(withUserIds userIds: [String]) {
        UserDefaults.standard.set(userIds, forKey: UserDefaultsKey.userIds)
    }
    
    // MARK: - Helpers
    
    func getDeviceToken() -> String {
        return UserDefaults.standard.value(forKey: UserDefaultsKey.deviceToken) as? String ?? ""
    }
    
    func startingPage() -> UIViewController {
        if isUserRegistered {
            return TabbarViewController()
        } else {
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterNavigationController")
        }
    }
    
}
