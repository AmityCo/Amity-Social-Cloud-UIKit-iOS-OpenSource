//
//  AmitySettingsItemRadioButtonContentTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 7/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

protocol AmitySettingsItemRadioButtonContentCellProtocol {
    func display(content: AmitySettingsItem.RadionButtonContent)
}


final class AmitySettingsItemRadioButtonContentTableViewCell: UITableViewCell, Nibbable, AmitySettingsItemRadioButtonContentCellProtocol {
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var titleLabel: AmityLabel!
    @IBOutlet private var radioButtonImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = AmityLocalizedStringSet.titlePlaceholder
        radioButtonImageView.image = nil
    }
    
    func display(content: AmitySettingsItem.RadionButtonContent) {
        titleLabel.text = content.title
        
        if content.isSelected {
            radioButtonImageView.image = AmityIconSet.iconRadioOn
            radioButtonImageView.tintColor = AmityColorSet.primary
        } else {
            radioButtonImageView.image = AmityIconSet.iconRadioOff
            radioButtonImageView.tintColor = AmityColorSet.base.blend(.shade2)
        }
        
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = AmityColorSet.backgroundColor
        contentView.backgroundColor = AmityColorSet.backgroundColor
        
        // MARK: - Title
        titleLabel.text = AmityLocalizedStringSet.titlePlaceholder
        titleLabel.font = AmityFontSet.body
        titleLabel.textColor = AmityColorSet.base
        titleLabel.numberOfLines = 0
    }
    
}
