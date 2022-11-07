//
//  ShareViewController.swift
//  Amity SampleApp for TrueID
//
//  Created by Mono TheForestcat on 6/9/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import AmityUIKit
import AmitySDK
import Social

class ShareViewController: UIViewController {
    var initialBounds: CGRect?
    var childVC: UIViewController = .init()
    
    deinit { }
    
    override func viewDidLoad() {
        setup()
    }
    
    @objc func close() { }
    
    func setup() {
        print("Start Share Extension")
//        let alert = UIAlertController(title: "Test", message: "Test alert", preferredStyle: .alert)
////        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: ))
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { UIAlertAction in
//            print("Extension OK!!")
//        }))
//        self.present(alert, animated: true)
    }
    
    @IBAction func startAction() {
        
        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
            AmityUIKitManager.set(extensionEventHandler: AmityCustomExtensionEventHandler())
            if let attachments = item.attachments {
                AmityUIKitManager.setup(apiKey: "b0eceb5e68ddf36545308f4e000b12dcd90985e2bf3d6a2e", region: .SG)
                
                
                if AmityUIKitManager.isClient {
                    debugPrint("Have")
                    AmityUIKitManager.registerDevice(withUserId: "1984118", displayName: "Mono29") { success, error in
                        if error != nil {
                            let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { UIAlertAction in
                                
                            }))
                            self.present(alert, animated: true)
                            return
                        }
                        let vc = AmityPostTargetPickerViewController.makePostBy(url: [], mediaType: .image)
                        let nav = UINavigationController(rootViewController: vc)
                        
                        nav.modalPresentationStyle = .fullScreen
                        self.present(nav, animated: true)
                    }
                } else {
                    debugPrint("Don't Have")
                    let alert = UIAlertController(title: "Error", message: "Not have client.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { UIAlertAction in
                        
                    }))
                    self.present(alert, animated: true)
                }
                
                
            }
        }
    }
}
