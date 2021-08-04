//
//  UIPanGestureRecognizer+Extension.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 15/7/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

extension UIPanGestureRecognizer {

    struct PanGestureDirection: OptionSet {
        public let rawValue: UInt8

        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }

        static let up = PanGestureDirection(rawValue: 1 << 0)
        static let down = PanGestureDirection(rawValue: 1 << 1)
        static let left = PanGestureDirection(rawValue: 1 << 2)
        static let right = PanGestureDirection(rawValue: 1 << 3)
    }

    private func getDirectionBy(velocity: CGFloat, greater: PanGestureDirection, lower: PanGestureDirection) -> PanGestureDirection {
        if velocity == 0 {
            return []
        }
        return velocity > 0 ? greater : lower
    }
    
    // return current directions
    func direction(in view: UIView) -> PanGestureDirection {
        let velocity = self.velocity(in: view)
        let yDirection = getDirectionBy(velocity: velocity.y, greater: PanGestureDirection.down, lower: PanGestureDirection.up)
        let xDirection = getDirectionBy(velocity: velocity.x, greater: PanGestureDirection.right, lower: PanGestureDirection.left)
        return xDirection.union(yDirection)
    }
    
}
