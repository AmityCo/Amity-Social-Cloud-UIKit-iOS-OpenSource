//
//  AmityUtilities.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 9/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

struct AmityUtilities {
    static func showError() {
        let alertController = UIAlertController(title: "Something wrong", message: "Please try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AmityLocalizedStringSet.General.ok.localizedString, style: .default, handler: nil))
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    static func showAlert(title: String?, message: String?, viewController: UIViewController, callBackOK:((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.setTitle(font: AmityFontSet.title)
        alertController.setMessage(font: AmityFontSet.body)
        let okAlert = UIAlertAction(title: AmityLocalizedStringSet.General.ok.localizedString, style: .default, handler: callBackOK)
        alertController.addAction(okAlert)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func UINibs(nibName: String) -> UINib {
        return UINib(nibName: nibName, bundle: AmityUIKitManager.bundle)
    }
}
