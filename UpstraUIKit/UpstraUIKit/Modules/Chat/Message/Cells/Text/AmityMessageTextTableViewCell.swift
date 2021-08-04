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
    
    @IBOutlet private var textMessageView: AmityTextMessageView!
    
    var messageReadmore: AmityMessageReadmoreModel!
    var readmoreHandler: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    private func setupView() {
        textMessageView.text = ""
        textMessageView.textAlignment = .left
        textMessageView.numberOfLines = 0
        textMessageView.textFont = AmityFontSet.body
        textMessageView.backgroundColor = .clear
        textMessageView.contentView.backgroundColor = .clear
        textMessageView.readmoreHandler = { [weak self] in
            guard let self = self else { return }
            self.readmoreHandler?()
        }
    }
        
    override func display(message: AmityMessageModel) {
        super.display(message: message)
        if message.isOwner {
            textMessageView.textColor = AmityColorSet.baseInverse
            textMessageView.readmoreTextColor = AmityColorSet.baseInverse
        } else {
            textMessageView.textColor = AmityColorSet.base
            textMessageView.readmoreTextColor = AmityColorSet.base
        }
        setText(message)
    }
    
    private func setText(_ message: AmityMessageModel) {
        if message.messageType == .text {
            textMessageView.message = message
            textMessageView.messageReadmore = messageReadmore
        }
    }
}
