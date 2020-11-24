//
//  Theme.swift
//  SampleApp
//
//  Created by Sarawoot Khunsri on 23/7/2563 BE.
//  Copyright © 2563 Eko. All rights reserved.
//

import UIKit
import UpstraUIKit

enum Preset: Int {
    case preset1
    case preset2
    
    var theme: EkoTheme {
        switch self {
        case .preset1:
            return EkoTheme()
        case .preset2:
            return EkoTheme(primary: .black, secondary: .red, alert: .green, highlight: .yellow, base: .green, baseInverse: .red, messageBubble: .green , messageBubbleInverse: .red)
        }
    }
}
