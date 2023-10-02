//
//  UINavigationController+Extension.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 14/7/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func setBackgroundColor(with color: UIColor, shadow: Bool = false) {
        if !shadow {
            navigationBar.shadowImage = UIImage()
        }
    }
    
    func reset() {
        navigationBar.backgroundColor = nil
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = nil
    }
    
    func previousViewController() -> UIViewController? {
        guard viewControllers.count > 1 else {
            return nil
        }
        return viewControllers[viewControllers.count - 2]
    }
}

