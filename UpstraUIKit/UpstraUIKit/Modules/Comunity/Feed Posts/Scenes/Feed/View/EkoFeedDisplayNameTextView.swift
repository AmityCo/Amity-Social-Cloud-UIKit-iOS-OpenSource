//
//  EkoFeedDisplayNameTextView.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 8/1/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import UIKit

protocol EkoFeedDisplayNameLabelDelegate: class {
    func labelDidTapUserDisplayName(_ label: EkoFeedDisplayNameLabel)
    func labelDidTapCommunityName(_ label: EkoFeedDisplayNameLabel)
}

class EkoFeedDisplayNameLabel: UILabel {
    
    private var displayName: String = ""
    private var communityName: String?
    
    weak var delegate: EkoFeedDisplayNameLabelDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        isUserInteractionEnabled = true
        numberOfLines = 3
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction(sender:)))
        addGestureRecognizer(tap)
    }
    
    func configure(displayName: String, communityName: String?) {
        self.displayName = displayName
        self.communityName = communityName
        
        let attributeString = NSMutableAttributedString()
        attributeString.append(NSAttributedString(string: displayName))
        
        if let communityName = communityName {
            attributeString.append(NSAttributedString(string: " ‣ "))
            attributeString.append(NSAttributedString(string: communityName))
        }
        let attributes: [NSAttributedString.Key : Any] = [.foregroundColor: EkoColorSet.base, .font: EkoFontSet.title]
        attributeString.addAttributes(attributes, range: NSRange(location: 0, length: attributeString.string.count) )
        attributedText = attributeString
    }
    
    @objc func tapFunction(sender: UITapGestureRecognizer) {
        let displayNameRange = (text! as NSString).range(of: displayName)
        let communityNameRange = (text! as NSString).range(of: communityName ?? "")

        if sender.didTapAttributedTextInLabel(label: self, inRange: displayNameRange) {
            delegate?.labelDidTapUserDisplayName(self)
        } else if sender.didTapAttributedTextInLabel(label: self, inRange: communityNameRange) {
            delegate?.labelDidTapCommunityName(self)
        }
    }
    
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(
            x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
            y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(
            x: (locationOfTouchInLabel.x - textContainerOffset.x),
            y: 0 );
        // Adjust for multiple lines of text
        let lineModifier = Int(ceil(locationOfTouchInLabel.y / label.font.lineHeight)) - 1
        let rightMostFirstLinePoint = CGPoint(x: labelSize.width, y: 0)
        let charsPerLine = layoutManager.characterIndex(for: rightMostFirstLinePoint, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        let adjustedRange = indexOfCharacter + (lineModifier * charsPerLine)
        
        return NSLocationInRange(adjustedRange, targetRange)
    }

}
