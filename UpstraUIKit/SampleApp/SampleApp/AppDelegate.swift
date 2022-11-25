//
//  AppDelegate.swift
//  SampleApp
//
//  Created by Sarawoot Khunsri on 15/7/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK
import AmityUIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Setup UNUserNotificationCenter to handle push notification.
        // https://developer.apple.com/documentation/usernotifications/
        UNUserNotificationCenter.current().delegate = self
        
        // Setup AmityUIKit
        AppManager.shared.setupAmityUIKit()
        
//        let myTypography = AmityTypography(
//            headerLine: UIFont(name: "NotoSansMyanmar-Bold", size: 20)!,
//            title: UIFont(name: "NotoSansMyanmar-Bold", size: 18)!,
//            bodyBold: UIFont(name: "NotoSansMyanmar-Regular", size: 16)!,
//            body: UIFont(name: "NotoSansMyanmar-Regular", size: 16)!,
//            captionBold: UIFont(name: "NotoSansMyanmar-Regular", size: 14)!,
//            caption: UIFont(name: "NotoSansMyanmar-Regular", size: 14)!)
        
        let myTypography = AmityTypography(
            headerLine: UIFont(name: "NotoSansThai-Bold", size: 20)!,
            title: UIFont(name: "NotoSansThai-Bold", size: 18)!,
            bodyBold: UIFont(name: "NotoSansThai-Regular", size: 16)!,
            body: UIFont(name: "NotoSansThai-Regular", size: 16)!,
            captionBold: UIFont(name: "NotoSansThai-Regular", size: 14)!,
            caption: UIFont(name: "NotoSansThai-Regular", size: 14)!)
        
        AmityUIKitManager.set(typography: myTypography)
        AmityUIKitManager.setUrlAdvertisement("https://home.trueid.net/campaign/nRNzQawWNm0R")
        AmityUIKitManager.setJSONBadgeUser("""
              {
               "group_profile": [
                  {
                     "enable": false,
                     "role": "admin",
                     "profile": [
                        {
                           "badge_icon": "https://cms.dmpcdn.com/livetv/2020/09/17/dfacfdc0-f8ca-11ea-93ca-b15d54ae9c1e_original.png",
                           "badge_description_en": "Chat admins ensure that chat is up to standards by removing offensive posts and spam that detracts from conversations. Feel free to chat with our admin team!",
                           "badge_title_en": "Chat Admin",
                           "badge_title_local": "แอดมินห้องแชท",
                           "badge_description_local": "แอดมินห้องแชท ทำหน้าที่ควบคุมมาตรฐานการแชท โดยการลบโพสต์และสแปมที่ไม่เหมาะสม ทำให้ทุกคนสามารถพูดคุยกันอย่างสนุกสนานไร้กังวล"
                        }
                     ]
                  },
                  {
                     "profile": [
                        {
                           "badge_title_local": "แฟนตัวยง",
                           "badge_description_local": "รับ เครื่องหมาย แฟนตัวยง ง่ายๆ เพียงแค่คุณเป็นหนึ่งในสมาชิกที่ใช้งานอย่างสม่ำเสมอ บน live chat ของทรูไอดี ซึ่งรวมไปถึงการส่งความรู้สึกตอบสนอง หรือแม้แต่การพิมพ์ตอบข้อความสมาชิกท่านอื่น เพียงแค่มีเครื่องหมายนี้ข้อความของคุณก็จะโดดเด่นเกินใคร!",
                           "badge_description_en": "Earn a super fan badge by being one of the most active member on True ID live chat, which include reacting and replying to other users’ messages",
                           "badge_title_en": "Super Fan",
                           "badge_icon": "https://cms.dmpcdn.com/livetv/2020/09/22/cc7a2be0-fcaa-11ea-b266-63e567a949c5_original.png"
                        }
                     ],
                     "role": "beginner",
                     "enable": false
                  },
                  {
                     "enable": false,
                     "role": "general",
                     "profile": [
                        {
                           "badge_title_local": "",
                           "badge_description_local": "",
                           "badge_description_en": "",
                           "badge_title_en": "",
                           "badge_icon": ""
                        }
                     ]
                  },
                  {
                     "enable": true,
                     "role": "rising-star",
                     "profile": [
                        {
                           "badge_description_en": "This badge awarded to the user who win TrueID campaign",
                           "badge_title_en": "The Winner",
                           "badge_title_local": "ผู้ชนะเลิศ",
                           "badge_icon": "https://cms.dmpcdn.com/livetv/2020/09/17/d65999e0-f8ca-11ea-93ca-b15d54ae9c1e_original.png",
                           "badge_description_local": "สัญลักษณ์นี้สำหรับสมาชิกที่มีส่วนร่วมและชนะการแข่งขันในกิจกรรมบน TrueID!"
                        }
                     ]
                  },
                  {
                     "profile": [
                        {
                           "badge_description_local": "สัญลักษณ์นี้สำหรับสมาชิกที่มีส่วนร่วมกับกิจกรรมบน TrueID มากที่สุด!",
                           "badge_title_local": "แฟนตัวยง",
                           "badge_description_en": "This badge awarded to the user who has provide high contributions in TrueID campaign",
                           "badge_icon": "https://cms.dmpcdn.com/livetv/2020/09/17/e6f612b0-f8ca-11ea-816f-61c1bc726fdd_original.png",
                           "badge_title_en": "Super Fan"
                        }
                     ],
                     "enable": true,
                     "role": "super-fan"
                  }
               ]
              }
              """)
        AmityUIKitManager.setJSONRegex("""
                {
                   "android": true,
                   "community_feature": [
                       "livestream",
                       "comment",
                       "post"
                   ],
                   "ios": true
                }
                """)

        if #available(iOS 13.0, *) {
            // on newer 13.0 version, the window setup finished on `SceneDelegate`
        } else {
            window = UIWindow()
            window?.rootViewController = AppManager.shared.startingPage()
            window?.makeKeyAndVisible()
        }
        
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

            let urlString = url.absoluteString //"https://Amity.co/post/124325135"
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
        AppManager.shared.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Fail didFailToRegisterForRemoteNotificationsWithError: \(error.localizedDescription)")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0  // reset badge counter
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
        AmityUIKitManager.registerDevice(withUserId: "victimIOS", displayName: "victimIOS".uppercased())
        
        let postDetailViewController = AmityPostDetailViewController.make(withPostId: "c1bb8697c88a01f6423765984a3e47ac")
        window?.rootViewController = postDetailViewController
        window?.makeKeyAndVisible()
    }
    
}
