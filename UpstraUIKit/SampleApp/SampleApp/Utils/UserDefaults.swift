//
//  UserDefaults.swift
//  SampleApp
//
//  Created by Sarawoot Khunsri on 24/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmityUIKit
extension UserDefaults {
    
    var theme: Int? {
        get {
            return integer(forKey: #function)
        } set {
            return set(newValue, forKey: #function)
        }
    }
    
}
