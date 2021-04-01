//
//  AppDelegate.swift
//  SampleApp
//
//  Created by Sarawoot Khunsri on 15/7/2563 BE.
//  Copyright © 2563 Eko. All rights reserved.
//

import UIKit
import EkoChat
import UpstraUIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Setup UNUserNotificationCenter to handle push notification.
        // https://developer.apple.com/documentation/usernotifications/
        UNUserNotificationCenter.current().delegate = self
        
        // Setup UpstraUIKit
        UpstraUIKitManager.setup("API_KEY")
        UpstraUIKitManager.set(eventHandler: CustomEventHandler())
        
        guard let preset = Preset(rawValue: UserDefaults.standard.theme ?? 0) else { return false }
        UpstraUIKitManager.set(theme: preset.theme)
        window = UIWindow()
        let registerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController")
        window?.rootViewController = registerVC
        window?.makeKeyAndVisible()
        
        UpstraUIKitManager.feedUISettings.eventHandler = CustomFeedEventHandler()
        UpstraUIKitManager.feedUISettings.setPostSharingSettings(settings: EkoPostSharingSettings())
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        // Handler of opening external url from web browsing session.
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL {

            let urlString = url.absoluteString //"https://upstra.co/post/124325135"
            // Parse url and be sure that it is a url of a post
            if urlString.contains("post/") {
                if let range = urlString.range(of: "post/") {
                    // Detect id of the post
                    let postId = String(urlString[range.upperBound...])
                    
                    // Open post details page
                    openPost(withId: postId)
                }
            }
        }
        
        return true
    }
    
    // MARK: Push Notification
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // https://developer.apple.com/documentation/usernotifications/registering_your_app_with_apns
        // Forward Tokens to Your Provider Server
        sendDeviceTokenToServer(token: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Fail didFailToRegisterForRemoteNotificationsWithError: \(error.localizedDescription)")
    }
    
    private func sendDeviceTokenToServer(token: Data) {
        // Transform deviceToken into a raw string, before sending to EkoChatSDK server.
        let tokenParts: [String] = token.map { data in String(format: "%02.2hhx", data) }
        let tokenString: String = tokenParts.joined()
        
        UpstraUIKitManager.registerDeviceForPushNotification(tokenString)
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // For this sample app, we allow every push notification, to present while the app is in foreground.
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
}

// MARK:- Helper methods
extension AppDelegate {
    
    private func openPost(withId postId: String) {
        window = UIWindow()
        UpstraUIKitManager.registerDevice(withUserId: "victimIOS", displayName: "victimIOS".uppercased())
        
        let postDetailViewController = EkoPostDetailViewController.make(withPostId: "c1bb8697c88a01f6423765984a3e47ac")
        window?.rootViewController = postDetailViewController
        window?.makeKeyAndVisible()
    }
    
}
