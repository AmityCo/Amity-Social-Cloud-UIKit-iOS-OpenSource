//
//  EkoSettingsItemRadioButtonContentTableViewCell.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 7/3/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import UIKit

protocol EkoSettingsItemRadioButtonContentCellProtocol {
    func display(content: EkoSettingsItem.RadionButtonContent)
}


final class EkoSettingsItemRadioButtonContentTableViewCell: UITableViewCell, Nibbable, EkoSettingsItemRadioButtonContentCellProtocol {
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var titleLabel: EkoLabel!
    @IBOutlet private var radioButtonImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = EkoLocalizedStringSet.titlePlaceholder
        radioButtonImageView.image = nil
    }
    
    func display(content: EkoSettingsItem.RadionButtonContent) {
        titleLabel.text = content.title
        
        if content.isSelected {
            radioButtonImageView.image = EkoIconSet.iconRadioOn
            radioButtonImageView.tintColor = EkoColorSet.primary
        } else {
            radioButtonImageView.image = EkoIconSet.iconRadioOff
            radioButtonImageView.tintColor = EkoColorSet.base.blend(.shade2)
        }
        
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = EkoColorSet.backgroundColor
        contentView.backgroundColor = EkoColorSet.backgroundColor
        
        // MARK: - Title
        titleLabel.text = EkoLocalizedStringSet.titlePlaceholder
        titleLabel.font = EkoFontSet.body
        titleLabel.textColor = EkoColorSet.base
        titleLabel.numberOfLines = 0
    }
    
}
