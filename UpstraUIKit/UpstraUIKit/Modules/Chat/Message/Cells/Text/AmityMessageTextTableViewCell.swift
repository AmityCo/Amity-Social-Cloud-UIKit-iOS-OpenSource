//
//  AmityMessageTextTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 30/7/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit
import AmitySDK

class AmityMessageTextTableViewCell: AmityMessageTableViewCell {
    
    weak var textDelegate: AmityExpandableLabelDelegate? {
        didSet {
            textMessageView.delegate = textDelegate
        }
    }
    
    @IBOutlet private var textMessageView: AmityExpandableLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    private func setupView() {
        textMessageView.text = ""
        textMessageView.textAlignment = .left
        textMessageView.numberOfLines = 8
        textMessageView.isExpanded = false
        textMessageView.font = AmityFontSet.body
        textMessageView.backgroundColor = .clear
    }
        
    override func display(message: AmityMessageModel) {
        super.display(message: message)
        if message.isOwner {
            textMessageView.textColor = AmityColorSet.baseInverse
            textMessageView.readMoreColor = AmityColorSet.baseInverse
            textMessageView.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 108 // [Large Spacing + Text Padding + Spacing] -> [72 + 24 + 12]
        } else {
            textMessageView.textColor = AmityColorSet.base
            textMessageView.readMoreColor = AmityColorSet.highlight
            textMessageView.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 160 // [Spacing + Avatar + Text Padding + Large Spacing] -> [12 + 40 + 24 + 72]
        }
        setText(message)
    }
    
    override class func height(for message: AmityMessageModel, boundingWidth: CGFloat) -> CGFloat {
        if message.isDeleted {
            let displaynameHeight: CGFloat = message.isOwner ? 0 : 22
            return AmityMessageTableViewCell.deletedMessageCellHeight + displaynameHeight
        }
        
        // for cell layout and calculation, please go check this pull request https://github.com/EkoCommunications/EkoMessagingSDKUIKitIOS/pull/713
        if message.isOwner {
            let horizontalPadding: CGFloat = 112
            let actualWidth = boundingWidth - horizontalPadding
            var height = message.text?.height(withConstrainedWidth: actualWidth, font: AmityFontSet.body) ?? 0.0
            height += 64
            return height
        } else {
            let horizontalPadding: CGFloat = 164
            let actualWidth = boundingWidth - horizontalPadding
            var height = message.text?.height(withConstrainedWidth: actualWidth, font: AmityFontSet.body) ?? 0.0
            height += 98
            return height
        }
    }
    
    private func setText(_ message: AmityMessageModel) {
        if message.messageType == .text {
            textMessageView.text = message.text
        }
    }
}
