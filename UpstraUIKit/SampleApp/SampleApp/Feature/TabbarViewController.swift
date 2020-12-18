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

        let feature = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeatureViewController")
        feature.tabBarItem.title = "Feature"
        
        let setting = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingViewController")
        setting.tabBarItem.title = "Setting"
        
        let test = EkoCommunityHomePageViewController.make()
        
        viewControllers = [UINavigationController(rootViewController: feature),
                           UINavigationController(rootViewController: setting),
                           UINavigationController(rootViewController: EkoCommunityHomePageViewController.make())]
    }
}
