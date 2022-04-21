//
//  SwiftUIPreferenceKey.swift
//  AmityUIKit
//
//  Created by Mono TheForestcat on 7/4/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation
import SwiftUI

struct AmityFullHeaderScrollValue: PreferenceKey {
    static var defaultValue: String = ""
    static var scrollValue: CGFloat = 0

    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}
