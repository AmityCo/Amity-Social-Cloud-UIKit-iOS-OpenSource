//
//  AppPreferenceKey.swift
//  AmityUIKit
//
//  Created by Jiratin Teean on 21/4/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import UIKit

class AppPreferenceKey {
    
    static let scrollValue = "scrollValue"
    
    var defaults: UserDefaults
    
    init() {
        defaults = UserDefaults(suiteName: "app")!
    }
    
    func setValueDouble(_ key: String, value: Double) {
        defaults.setValue(value, forKey: key)
    }
    
    func getValueDouble(_ key: String) -> Double {
        let value = defaults.object(forKey: key)
        return value == nil ? 0 : value as! Double
    }
    
    func synchronize() {
        defaults.synchronize()
    }
    
    func clear() {
        for key in Array(defaults.dictionaryRepresentation().keys) {
            defaults.removeObject(forKey: key)
        }
    }
    
}
