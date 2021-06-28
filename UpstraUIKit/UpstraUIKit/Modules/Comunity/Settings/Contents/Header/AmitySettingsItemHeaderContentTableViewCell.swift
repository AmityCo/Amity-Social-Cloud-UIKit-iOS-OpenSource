//
//  AmitySettingsItemHeaderContentTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 7/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

protocol AmitySettingsItemHeaderCellProtocol {
    func display(content: AmitySettingsItem.HeaderContent)
}

final class AmitySettingsItemHeaderContentTableViewCell: UITableViewCell, Nibbable, AmitySettingsItemHeaderCellProtocol {

    // MARK: - IBOutlet Properties
    @IBOutlet private var titleLabel: AmityLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = AmityLocalizedStringSet.titlePlaceholder
    }
    
    func display(content: AmitySettingsItem.HeaderContent) {
        titleLabel.text = content.title
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = AmityColorSet.backgroundColor
        contentView.backgroundColor = AmityColorSet.backgroundColor
        
        // MARK: - Title
        titleLabel.text = AmityLocalizedStringSet.titlePlaceholder
        titleLabel.font = AmityFontSet.title
        titleLabel.textColor = AmityColorSet.base
    }
}
