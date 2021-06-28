//
//  AmitySettingContentIcon.swift
//  AmityUIKit
//
//  Created by Hamlet on 16.03.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

// Some settings won't have background.
// This model is helper to handle background show/hide actions
struct AmitySettingContentIcon {
    let icon: UIImage?
    let hasBackground: Bool

    init(icon: UIImage?, hasBackground: Bool = true) {
        self.icon = icon
        self.hasBackground = hasBackground
    }
}
