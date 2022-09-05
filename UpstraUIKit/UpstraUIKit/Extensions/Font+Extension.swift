//
//  Font+Extension.swift
//  AmityUIKit
//
//  Created by Mono TheForestcat on 5/9/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation
import SwiftUI

public extension Font {
  init(uiFont: UIFont) {
    self = Font(uiFont as CTFont)
  }
}
