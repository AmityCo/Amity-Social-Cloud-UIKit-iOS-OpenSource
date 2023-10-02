//
//  AmityExpandableLabelTests.swift
//  AmityUIKitTests
//
//  Created by Nontapat Siengsanor on 24/5/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import XCTest
@testable import AmityUIKit

class AmityExpandableLabelTests: XCTestCase {
    
    func testHeightForText() {
        let font = AmityFontSet.body
        let boundingWidth: CGFloat = 100
        
        let oneLineText = NSAttributedString(string: "a", attributes: [.font: font])
        let oneLineTextHeight = oneLineText.boundingRect(for: boundingWidth).height
        assert(ceil(oneLineTextHeight) == 18)

        let twoLineText = NSAttributedString(string: "AAAA AAAA\nBBBB BBBB", attributes: [.font: font])
        let twoLineTextHeight = twoLineText.boundingRect(for: boundingWidth).height
        assert(twoLineTextHeight == oneLineTextHeight * 2)

        let lines = 20
        let texts = Array(repeating: "Lorem ipsum/n", count: lines - 1).joined()
        let multipleLineText = NSAttributedString(string: texts, attributes: [.font: font])
        let multipleLineTextHeight = multipleLineText.boundingRect(for: boundingWidth).height
        assert(multipleLineTextHeight == oneLineTextHeight * CGFloat(lines), "Height must be equal to \(multipleLineTextHeight)")
    }

}
