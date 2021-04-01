//
//  TabbarViewController.swift
//  SampleApp
//
//  Created by Sarawoot Khunsri on 20/7/2563 BE.
//  Copyright © 2563 Eko. All rights reserved.
//

import UpstraUIKit
import UIKit

class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let feature = UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeatureViewController"))
        feature.tabBarItem.title = "Feature"
        
        let setting = UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingViewController"))
        setting.tabBarItem.title = "Setting"
        
        viewControllers = [ feature,
                            setting,
                           /* UINavigationController(rootViewController: EkoCommunityHomePageViewController.make()) */]
        
        registerForPushNotifications()
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                guard granted else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
    }
    
}
