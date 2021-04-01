//
//  EkoSettingsItemNavigationContentTableViewCell.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 7/3/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import UIKit

protocol EkoSettingsItemNavigationContentCellProtocol {
    func display(content: EkoSettingsItem.NavigationContent)
}

final class EkoSettingsItemNavigationContentTableViewCell: UITableViewCell, Nibbable, EkoSettingsItemNavigationContentCellProtocol {

    @IBOutlet private var iconView: EkoIconView!
    @IBOutlet private var titleLabel: EkoLabel!
    @IBOutlet private var descriptionLabel: EkoLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.image = nil
        iconView.isHidden = false
        titleLabel.text = EkoLocalizedStringSet.titlePlaceholder
        descriptionLabel.text = EkoLocalizedStringSet.descriptionPlaceholder
    }

    
    func display(content: EkoSettingsItem.NavigationContent) {
        iconView.image = content.icon
        iconView.isHidden = content.icon == nil
        titleLabel.text = content.title
        descriptionLabel.text = content.description
        descriptionLabel.isHidden = content.description == nil
    }
    
    // MARK: - Setup views
    private func setupView() {
        selectionStyle = .none
        backgroundColor = EkoColorSet.backgroundColor
        contentView.backgroundColor = EkoColorSet.backgroundColor
        
        // Title
        titleLabel.text = EkoLocalizedStringSet.titlePlaceholder
        titleLabel.font = EkoFontSet.body
        titleLabel.textColor = EkoColorSet.base
        
        // Description
        descriptionLabel.text = EkoLocalizedStringSet.descriptionPlaceholder
        descriptionLabel.font = EkoFontSet.caption
        descriptionLabel.textColor = EkoColorSet.base.blend(.shade1)
        descriptionLabel.textAlignment = .right
        descriptionLabel.numberOfLines = 0
    }
}
