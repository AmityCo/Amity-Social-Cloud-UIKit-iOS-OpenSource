//
//  AmityFeedDisplayNameTextView.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 8/1/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

protocol AmityFeedDisplayNameLabelDelegate: AnyObject {
    func labelDidTapUserDisplayName(_ label: AmityFeedDisplayNameLabel)
    func labelDidTapCommunityName(_ label: AmityFeedDisplayNameLabel)
}

class AmityFeedDisplayNameLabel: UILabel {
    
    private var displayName: String = ""
    private var communityName: String?
    
    weak var delegate: AmityFeedDisplayNameLabelDelegate?
    
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
    
    func configure(displayName: String, communityName: String?, isOfficial: Bool, shouldShowCommunityName: Bool, shouldShowBannedSymbol: Bool) {
        self.displayName = displayName
        self.communityName = communityName
        
        let attributeString = NSMutableAttributedString()
        attributeString.append(NSAttributedString(string: displayName))
        
        if shouldShowBannedSymbol {
            let imageRightAttachment = NSTextAttachment()
            imageRightAttachment.image = AmityIconSet.CommunitySettings.iconCommunitySettingBanned?.setTintColor(AmityColorSet.base.blend(.shade3))
            imageRightAttachment.bounds = CGRect(x: 0, y: -2, width: 16, height: 16)
            let attachmentRightString = NSAttributedString(attachment: imageRightAttachment)
            attributeString.append(attachmentRightString)
        }
        
        // configure community displayname
        if shouldShowCommunityName, let communityName = communityName {
            attributeString.append(NSAttributedString(string: " ‣ "))
            attributeString.append(NSAttributedString(string: communityName))
        }
        
        let attributes: [NSAttributedString.Key : Any] = [.foregroundColor: AmityColorSet.base, .font: AmityFontSet.bodyBold]
        attributeString.addAttributes(attributes, range: NSRange(location: 0, length: attributeString.string.utf16.count) )
        attributedText = attributeString
        
        // configure official badge
        let shouldShowBadge = (shouldShowCommunityName && isOfficial)
        setImageWithText(position: .right(image: shouldShowBadge ? AmityIconSet.iconBadgeCheckmark : nil), size: CGSize(width: 18, height: 18), tintColor: AmityColorSet.highlight)
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
        
        var alignmentOffset: CGFloat = 0.0
        switch label.textAlignment {
        case .left, .natural, .justified:
            alignmentOffset = 0.0
        case .center:
            alignmentOffset = 0.5
        case .right:
            alignmentOffset = 1.0
        @unknown default:
            fatalError()
        }
        
        let textContainerOffset = CGPoint(
            x: (labelSize.width - textBoundingBox.size.width) * alignmentOffset - textBoundingBox.origin.x,
            y: (labelSize.height - textBoundingBox.size.height) * alignmentOffset - textBoundingBox.origin.y);
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
