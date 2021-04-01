//
//  UILabel+Extension.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 16/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

extension UILabel {
    
    func markAsMandatoryField() {
        guard let text = text else { return }
        let attributedText = NSMutableAttributedString(string: text, attributes: [.font: font, .foregroundColor: textColor])
        let asterisk = NSAttributedString(string: "*", attributes: [.font: font, .foregroundColor: EkoColorSet.alert])
        attributedText.append(asterisk)
        self.attributedText = attributedText
    }
    
    public func setLineSpacing(_ spacing: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineBreakMode = lineBreakMode
        attributedText = NSAttributedString(string: text ?? "", attributes: [
            .paragraphStyle: paragraphStyle
        ])
    }
    
    enum Position {
        case left(image: UIImage?), right(image: UIImage?), both(imageLeft: UIImage?, imageRight: UIImage?)
    }
    
    func setImageWithText(position: Position, size: CGSize? = nil, tintColor: UIColor? = nil) {
        // Initialize mutable string
        let completeText = NSMutableAttributedString()
        let imageOffsetY: CGFloat = -2
        switch position {
        case .left(let image):
            // Add image to mutable string
            if image != nil {
                let imageLeftAttachment = NSTextAttachment()
                imageLeftAttachment.image = image?.setTintColor(tintColor ?? EkoColorSet.base)
                imageLeftAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageLeftAttachment.image!.size.width, height: imageLeftAttachment.image!.size.height)
                let attachmentLeftString = NSAttributedString(attachment: imageLeftAttachment)
                completeText.append(attachmentLeftString)
            }
            // Add your text to mutable string
            let textAfterIcon = attributedText ?? NSAttributedString(string: text ?? "")
            // Add image to mutable string

            completeText.append(textAfterIcon)
            
            attributedText = completeText
        case .right(let image):
            // Add your text to mutable string
            let textBeforeIcon = attributedText ?? NSAttributedString(string: text ?? "")
            completeText.append(textBeforeIcon)
            // Add image to mutable string
            if image != nil {
                let imageRightAttachment = NSTextAttachment()
                imageRightAttachment.image = image?.setTintColor(tintColor ?? EkoColorSet.base)
                imageRightAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: size?.width ?? imageRightAttachment.image!.size.width, height: size?.height ?? imageRightAttachment.image!.size.height)
                let attachmentRightString = NSAttributedString(attachment: imageRightAttachment)
                completeText.append(attachmentRightString)
            }
            attributedText = completeText
        case let .both(imageLeft, imageRight):
            // Add image to mutable string
            if imageLeft != nil {
                let imageLeftAttachment = NSTextAttachment()
                imageLeftAttachment.image = imageLeft?.setTintColor(tintColor ?? EkoColorSet.base)
                imageLeftAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: size?.width ?? imageLeftAttachment.image!.size.width, height: size?.height ?? imageLeftAttachment.image!.size.height)
                let attachmentLeftString = NSAttributedString(attachment: imageLeftAttachment)
                completeText.append(attachmentLeftString)
            }
            
            // Add your text to mutable string
            let textCenterIcon = attributedText ?? NSAttributedString(string: text ?? "")
            completeText.append(textCenterIcon)
            // Add image to mutable string
            if imageRight != nil {
                let imageRightAttachment = NSTextAttachment()
                imageRightAttachment.image = imageRight?.setTintColor(tintColor ?? EkoColorSet.base)
                imageRightAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: size?.width ?? imageRightAttachment.image!.size.width, height: size?.height ?? imageRightAttachment.image!.size.height)
                let attachmentRightString = NSAttributedString(attachment: imageRightAttachment)
                completeText.append(attachmentRightString)
            }
            attributedText = completeText
        }
    }

    var isTruncated: Bool {
        guard let text = text else {
            return false
        }
        
        let size = CGSize(width: frame.size.width, height: .greatestFiniteMagnitude)
        let textSize = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: font],context: nil).size
        return textSize.height > bounds.size.height
    }
    
}
