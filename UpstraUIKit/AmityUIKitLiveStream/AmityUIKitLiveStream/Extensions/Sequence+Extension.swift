//
//  Sequence+Extension.swift
//  AmityUIKitLiveStream
//
//  Created by Mono TheForestcat on 26/9/2565 BE.
//

import Foundation
import UIKit

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
