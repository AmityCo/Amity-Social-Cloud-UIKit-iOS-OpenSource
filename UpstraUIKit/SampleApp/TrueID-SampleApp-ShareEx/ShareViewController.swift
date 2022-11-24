//
//  ShareViewController.swift
//  Amity SampleApp for TrueID
//
//  Created by Mono TheForestcat on 6/9/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import AmityUIKit
import Foundation
import MobileCoreServices
import Photos
import SwiftUI
import UIKit

public struct ProviderItemType {
    var isImage: Bool = false
    var isVideo: Bool = false
}

class ShareViewController: UIViewController {
    var initialBounds: CGRect?
    var childVC: UIViewController = .init()
    var isProviderItem: ProviderItemType = .init()
    var asset: [URL] = []
    
    private var imageContent: String {
        if #available(iOS 15.0, *) {
            return UTType.png.identifier
        }
        return kUTTypeImage as String
    }

    private var movieContent: String {
        if #available(iOS 15.0, *) {
            return UTType.quickTimeMovie.identifier
        }
        return kUTTypeMovie as String
    }

    
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
                
                for attach in attachments {
                    if attach.hasItemConformingToTypeIdentifier(imageContent) {
                        attach.loadItem(forTypeIdentifier: imageContent,
                                          options: nil) { [unowned self] data, error in
                            guard error == nil else { return }
                            isProviderItem.isImage = true
                            if let url = data as? URL {
                                asset.append(url)
                            }
                        }
                        // Video Type
                    } else if attach.hasItemConformingToTypeIdentifier(movieContent) {
                        attach.loadItem(forTypeIdentifier: movieContent,
                                          options: nil) { [unowned self] data, error in
                            guard error == nil else { return }
                            isProviderItem.isVideo = true
                            if let url = data as? URL {
                                asset.append(url)
                            }
                        }
                    }
                }
                
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
                        
                        if self.isProviderItem.isImage {
                            let vc = AmityPostTargetPickerViewController.makePostBy(url: self.asset, mediaType: .image)
                            let nav = UINavigationController(rootViewController: vc)
                            
                            nav.modalPresentationStyle = .fullScreen
                            self.present(nav, animated: true)
                        } else {
                            let vc = AmityPostTargetPickerViewController.makePostBy(url: self.asset, mediaType: .video)
                            let nav = UINavigationController(rootViewController: vc)
                            
                            nav.modalPresentationStyle = .fullScreen
                            self.present(nav, animated: true)
                        }
                        
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
