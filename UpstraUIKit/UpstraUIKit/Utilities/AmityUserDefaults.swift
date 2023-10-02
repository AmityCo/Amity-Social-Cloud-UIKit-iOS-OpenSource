//
//  AmityUserModelDefaults.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 11/6/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

// Note:
// See more reference: https://medium.com/@nishan/learn-property-wrappers-in-swift-in-10-minutes-281f5048dbb6

// We make our Property Wrapper Generic.
@propertyWrapper
struct Store<T> {

    // This is the key that user can provide
    var key: String
    
    // The default value for the property
    var defaultValue: T
    
    // Now it returns Generic value instead of Bool
    var wrappedValue: T {
        set { UserDefaults.standard.set(newValue, forKey: key) }
        get { UserDefaults.standard.value(forKey: key) as? T ?? defaultValue }
    }
    
    // We ask both key and default value during initialization.
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

struct AmityUserModelDefaults {
    private init() { }
    @Store(key: "is_dark_mode_enabled", defaultValue: false) static var isDarkModeEnabled: Bool
}
