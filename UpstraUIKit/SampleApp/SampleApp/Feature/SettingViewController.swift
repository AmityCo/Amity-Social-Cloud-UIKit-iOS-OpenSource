//
//  SettingViewController.swift
//  SampleApp
//
//  Created by Sarawoot Khunsri on 21/7/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmityUIKit

class SettingViewController: UIViewController {
    
    private var notificaionSettingButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificaionSettingButtonItem = UIBarButtonItem(title: "User Notifications", style: .plain, target: self, action: #selector(settingTap))
        navigationItem.rightBarButtonItem = notificaionSettingButtonItem
    }
    
    @IBAction func selectCustomizeTheme(_ sender: UIButton) {
        
        guard let preset = Preset(rawValue: sender.tag) else { return }
        UserDefaults.standard.theme = sender.tag
        AmityUIKitManager.set(theme: preset.theme)
        
        let alert = UIAlertController(title: "Customize Theme", message: "Selected \(preset)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    @IBAction func colorPaletteTap(_ sender: Any) {
        let colorPaletteVC = AmityColorPaletteTableViewController()
        navigationController?.pushViewController(colorPaletteVC, animated: true)
    }
    
    @objc private func settingTap() {
        let userPushNotificationVC = UserLevelPushNotificationsTableViewController()
        navigationController?.pushViewController(userPushNotificationVC, animated: true)
    }
    
}
