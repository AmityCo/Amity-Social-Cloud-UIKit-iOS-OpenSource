//
//  EkoMessageDateView.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 30/8/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

class EkoMessageDateView: EkoView {
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var dateLabel: UILabel!
    
    // MARK: - Properties
    var text: String? {
        didSet {
            dateLabel.text = text
        }
    }
    
    override func initial() {
        loadNibContent()
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        containerView.backgroundColor = EkoColorSet.base.blend(.shade4)
        containerView.layer.cornerRadius = containerView.frame.height / 2
        
        dateLabel.textColor = EkoColorSet.base
        dateLabel.font = EkoFontSet.caption
        
    }
    
}
