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
    
    static func UINibs(nibName: String) -> UINib {
        return UINib(nibName: nibName, bundle: AmityUIKitManager.bundle)
    }
}
