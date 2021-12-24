//
//  CustomMessageTextIncomingTableViewCell.swift
//  SampleApp
//
//  Created by Sarawoot Khunsri on 23/11/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit
import AmityUIKit

class CustomMessageTextIncomingTableViewCell: UITableViewCell, AmityMessageCellProtocol {

    @IBOutlet private var displayTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    func display(message: AmityMessageModel) {
        if let text = message.data?["text"] as? String {
            let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            if let matches = detector?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) {
                let attributedString = NSMutableAttributedString(string: text)
                
                for match in matches {
                    let range = NSRange(location: match.range.location, length: match.range.length)
                    guard range.location != NSNotFound, range.location < text.count else { continue }
                    attributedString.addAttribute(.foregroundColor, value: UIColor(hex: "#1054DE"), range: range)
                    attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
                }
                
                displayTextLabel.attributedText = attributedString
            } else {
                displayTextLabel.text = text
            }
        }
    }
}
