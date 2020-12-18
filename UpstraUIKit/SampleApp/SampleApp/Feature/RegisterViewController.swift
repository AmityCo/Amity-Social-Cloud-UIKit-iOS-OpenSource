//
//  RegisterViewController.swift
//  SampleApp
//
//  Created by Sarawoot Khunsri on 21/7/2563 BE.
//  Copyright © 2563 Eko. All rights reserved.
//

import UIKit
import UpstraUIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet private var versionLabel: UILabel!
    @IBOutlet private var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.placeholder = "Login as `victimIOS` please leave it empty"
        
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        
        versionLabel.text = "\(version) build \(build)"
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func featureButtonTap() {
        register()
    }
    
    @IBAction func moderatorRoleTap() {
        register()
    }
    
    private func register() {
        let userId = textField.text!.isEmpty ? "victimIOS" : textField.text!
        UpstraUIKitManager.registerDevice(withUserId: userId, displayName: userId.uppercased())
        
        UIApplication.shared.windows.first?.rootViewController = TabbarViewController()
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
}
