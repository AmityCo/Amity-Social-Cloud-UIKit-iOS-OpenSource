//
//  SettingViewController.swift
//  SampleApp
//
//  Created by Sarawoot Khunsri on 21/7/2563 BE.
//  Copyright © 2563 Eko. All rights reserved.
//

import UIKit
import UpstraUIKit

class SettingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func selectCustomizeTheme(_ sender: UIButton) {
        
        guard let preset = Preset(rawValue: sender.tag) else { return }
        UserDefaults.standard.theme = sender.tag
        UpstraUIKit.set(theme: preset.theme)
        
        let alert = UIAlertController(title: "Customize Theme", message: "Selected Preset \(sender.tag + 1)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    @IBAction func colorPaletteTap(_ sender: Any) {
        let colorPaletteVC = EkoColorPaletteTableViewController()
        navigationController?.pushViewController(colorPaletteVC, animated: true)
    }
    
}
