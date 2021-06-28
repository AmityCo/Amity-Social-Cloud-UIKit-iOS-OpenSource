//
//  AmityLabel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 6/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

final class AmityLabel: UILabel {
    
    override var text: String? {
        didSet {
            updateLineSpacing()
        }
    }
    
    var lineSpacing: CGFloat = 4 {
        didSet {
            updateLineSpacing()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateLineSpacing()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateLineSpacing()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateLineSpacing()
    }
    
    private func updateLineSpacing() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineBreakMode = lineBreakMode
        attributedText = NSAttributedString(string: text ?? "",
                                            attributes: [
                                                .paragraphStyle: paragraphStyle
                                            ])
    }
}
