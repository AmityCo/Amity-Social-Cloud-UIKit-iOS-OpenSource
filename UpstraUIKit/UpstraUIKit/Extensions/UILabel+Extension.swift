//
//  UILabel+Extension.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 16/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

extension UILabel {
    enum Position {
        case left(image: UIImage?), right(image: UIImage?), both(imageLeft: UIImage?, imageRight: UIImage?)
    }
    
    func setImageWithText(position: Position) {
        // Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        let imageOffsetY: CGFloat = -5
        switch position {
        case .left(let image):
            // Add image to mutable string
            if image != nil {
                let imageLeftAttachment = NSTextAttachment()
                imageLeftAttachment.image = image
                imageLeftAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageLeftAttachment.image!.size.width, height: imageLeftAttachment.image!.size.height)
                let attachmentLeftString = NSAttributedString(attachment: imageLeftAttachment)
                completeText.append(attachmentLeftString)
            }
            // Add your text to mutable string
            let textAfterIcon = NSAttributedString(string: text ?? "")
            // Add image to mutable string

            completeText.append(textAfterIcon)
            
            attributedText = completeText
        case .right(let image):
            // Add your text to mutable string
            let textBeforeIcon = NSAttributedString(string: text ?? "")
            completeText.append(textBeforeIcon)
            // Add image to mutable string
            if image != nil {
                let imageRightAttachment = NSTextAttachment()
                imageRightAttachment.image = image
                imageRightAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageRightAttachment.image!.size.width, height: imageRightAttachment.image!.size.height)
                let attachmentRightString = NSAttributedString(attachment: imageRightAttachment)
                completeText.append(attachmentRightString)
            }
            attributedText = completeText
        case let .both(imageLeft, imageRight):
            // Add image to mutable string
            if imageLeft != nil {
                let imageLeftAttachment = NSTextAttachment()
                imageLeftAttachment.image = imageLeft
                imageLeftAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageLeftAttachment.image!.size.width, height: imageLeftAttachment.image!.size.height)
                let attachmentLeftString = NSAttributedString(attachment: imageLeftAttachment)
                completeText.append(attachmentLeftString)
            }
            
            // Add your text to mutable string
            let textCenterIcon = NSAttributedString(string: text ?? "")
            completeText.append(textCenterIcon)
            // Add image to mutable string
            if imageRight != nil {
                let imageRightAttachment = NSTextAttachment()
                imageRightAttachment.image = imageRight
                imageRightAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageRightAttachment.image!.size.width, height: imageRightAttachment.image!.size.height)
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
