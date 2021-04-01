//
//  EkoSettingContentIcon.swift
//  UpstraUIKit
//
//  Created by Hamlet on 16.03.21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

// Some settings won't have background.
// This model is helper to handle background show/hide actions
struct EkoSettingContentIcon {
    let icon: UIImage?
    let hasBackground: Bool

    init(icon: UIImage?, hasBackground: Bool = true) {
        self.icon = icon
        self.hasBackground = hasBackground
    }
}
