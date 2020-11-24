//
//  EkoMessageTextTableViewCell.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 30/7/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit
import EkoChat

class EkoMessageTextTableViewCell: EkoMessageTableViewCell {
    
    @IBOutlet private var textMessageView: EkoTextMessageView!
    
    var messageReadmore: EkoMessageReadmoreModel!
    var readmoreHandler: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    private func setupView() {
        textMessageView.text = ""
        textMessageView.textAlignment = .left
        textMessageView.numberOfLines = 0
        textMessageView.textFont = EkoFontSet.body
        textMessageView.backgroundColor = .clear
        textMessageView.contentView.backgroundColor = .clear
        textMessageView.readmoreHandler = { [weak self] in
            guard let self = self else { return }
            self.readmoreHandler?()
        }
    }
        
    override func display(message: EkoMessageModel) {
        super.display(message: message)
        if message.isOwner {
            textMessageView.textColor = EkoColorSet.baseInverse
            textMessageView.readmoreTextColor = EkoColorSet.baseInverse
        } else {
            textMessageView.textColor = EkoColorSet.base
            textMessageView.readmoreTextColor = EkoColorSet.base
        }
        setText(message)
    }
    
    private func setText(_ message: EkoMessageModel) {
        if message.messageType == .text {
            textMessageView.message = message
            textMessageView.messageReadmore = messageReadmore
        }
    }
}
