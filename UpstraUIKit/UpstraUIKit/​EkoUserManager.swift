//
//  ​EkoUserManager.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 13/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoUserManager {
    private init() { }
    public static let shared = EkoUserManager()
    
    var roles: Set<String> = Set<String>()
    
    func isModerator() -> Bool {
        return false
        guard let userRoles = UpstraUIKitManagerInternal.shared.client.currentUser?.object?.roles as? [String] else { return false }
        
        for element in userRoles where element == "moderator" {
            for item in roles where item == element {
                return true
            }
        }
        return false
    }
}
