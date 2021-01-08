//
//  EkoSelectMemberListHeaderView.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 30/8/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

final class EkoSelectMemberListHeaderView: EkoView {
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var titleLabel: UILabel!
    
    // MARK: - Properties
    var text: String? {
        didSet {
            titleLabel.text = text
        }
    }
    
    override func initial() {
        loadNibContent()
        setupView()
    }
    
    private func setupView() {
        contentView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        
        titleLabel.text = ""
        titleLabel.textColor = EkoColorSet.base.blend(.shade3)
        titleLabel.font = EkoFontSet.bodyBold
    }

}
