//
//  EkoUtilities.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 9/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

struct EkoUtilities {
    static func showError() {
        let alertController = UIAlertController(title: "Something wrong", message: "Please try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: EkoLocalizedStringSet.ok.localizedString, style: .default, handler: nil))
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    static func UINibs(nibName: String) -> UINib {
        return UINib(nibName: nibName, bundle: UpstraUIKitManager.bundle)
    }
}
