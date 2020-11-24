//
//  UserDefaults.swift
//  SampleApp
//
//  Created by Sarawoot Khunsri on 24/8/2563 BE.
//  Copyright © 2563 Eko. All rights reserved.
//

import UIKit
import UpstraUIKit
extension UserDefaults {
    
    var theme: Int? {
        get {
            return integer(forKey: #function)
        } set {
            return set(newValue, forKey: #function)
        }
    }
    
}
