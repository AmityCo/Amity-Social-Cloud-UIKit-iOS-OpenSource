//
//  TabbarViewController.swift
//  SampleApp
//
//  Created by Sarawoot Khunsri on 20/7/2563 BE.
//  Copyright © 2563 Eko. All rights reserved.
//

import UIKit


class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let feature = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeatureViewController")
        feature.tabBarItem.title = "Feature"
        
        let setting = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingViewController")
        setting.tabBarItem.title = "Setting"
        viewControllers = [feature, setting]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
