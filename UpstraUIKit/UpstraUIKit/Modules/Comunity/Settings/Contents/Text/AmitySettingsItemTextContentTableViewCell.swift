//
//  AmitySettingsItemTextContentTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 7/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

protocol AmitySettingsItemTextContentCellProtocol {
    func display(content: AmitySettingsItem.TextContent)
}

final class AmitySettingsItemTextContentTableViewCell: UITableViewCell, Nibbable, AmitySettingsItemTextContentCellProtocol {

    // MARK: - IBOutlet Properties
    @IBOutlet private var iconView: AmityIconView!
    @IBOutlet private var titleLabel: AmityLabel!
    @IBOutlet private var descriptionLabel: AmityLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.image = nil
        iconView.isHidden = false
        titleLabel.text = AmityLocalizedStringSet.titlePlaceholder
        descriptionLabel.text = AmityLocalizedStringSet.descriptionPlaceholder
    }

    func display(content: AmitySettingsItem.TextContent) {
        iconView.image = content.icon
        iconView.isHidden = content.icon == nil
        titleLabel.text = content.title
        titleLabel.textColor = content.titleTextColor
        descriptionLabel.text = content.description
        descriptionLabel.isHidden = content.description == nil
    }
    
    // MARK: - Setup view
    private func setupView() {
        selectionStyle = .none
        backgroundColor = AmityColorSet.backgroundColor
        contentView.backgroundColor = AmityColorSet.backgroundColor
        
        // Title
        titleLabel.text = AmityLocalizedStringSet.titlePlaceholder
        titleLabel.font = AmityFontSet.bodyBold
        titleLabel.textColor = AmityColorSet.base
        
        // Description
        descriptionLabel.text = AmityLocalizedStringSet.descriptionPlaceholder
        descriptionLabel.font = AmityFontSet.caption
        descriptionLabel.textColor = AmityColorSet.base.blend(.shade1)
        descriptionLabel.numberOfLines = 0
        
    }
}
