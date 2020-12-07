//
//  EkoLocalizable.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 8/6/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

struct EkoLocalizable {
    private init() { }
    static func localizedString(forKey key: String) -> String {
        let string = NSLocalizedString(key, tableName: "EkoLocalizable", bundle: UpstraUIKitManager.bundle, value: "", comment: "")
        return string
    }
}
