//
//  AmitySettingsItemToggleContentTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 7/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

protocol AmitySettingsItemToggleContentCellDelegate: AnyObject {
    func didPerformActionToggleContent(withContent content: AmitySettingsItem.ToggleContent)
}

protocol AmitySettingsItemToggleContentCellProtocol {
    func display(content: AmitySettingsItem.ToggleContent)
}

final class AmitySettingsItemToggleContentTableViewCell: UITableViewCell, Nibbable, AmitySettingsItemToggleContentCellProtocol {

    weak var delegate: AmitySettingsItemToggleContentCellDelegate?
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var iconView: AmityIconView!
    @IBOutlet private var titleLabel: AmityLabel!
    @IBOutlet private var descriptionLabel: AmityLabel!
    @IBOutlet private var toggleSwitch: UISwitch!
    
    // MARK: - Properties
    private var model: AmitySettingsItem.ToggleContent?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.image = nil
        titleLabel.text = AmityLocalizedStringSet.titlePlaceholder
        descriptionLabel.text = AmityLocalizedStringSet.descriptionPlaceholder
        toggleSwitch.setOn(false, animated: false)
    }
    
    func display(content: AmitySettingsItem.ToggleContent) {
        model = content
        iconView.image = content.iconContent?.icon
        iconView.isHidden = content.iconContent?.icon == nil

        if let hasBackground = content.iconContent?.hasBackground, hasBackground {
            iconView.backgroundIcon = AmityColorSet.base.blend(.shade4)
        } else {
            iconView.backgroundIcon = .none
        }

        titleLabel.text = content.title
        descriptionLabel.text = content.description
        descriptionLabel.isHidden = content.description == nil
        toggleSwitch.setOn(content.isToggled, animated: true)
        content.callback = { [weak self] isToggled in
            self?.toggleSwitch.setOn(isToggled, animated: true)
        }
    }
    
    // MARK: - Setup views
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
        
        // Toggle Switch
        toggleSwitch.onTintColor = AmityColorSet.primary
        toggleSwitch.tintColor = AmityColorSet.base.blend(.shade3)
        toggleSwitch.backgroundColor = AmityColorSet.base.blend(.shade3)
        toggleSwitch.layer.cornerRadius = toggleSwitch.frame.height / 2
    }
  
}

// MARK: - Action
private extension AmitySettingsItemToggleContentTableViewCell {
    @IBAction func toggleValuChanged(_ toggleSwitch: UISwitch) {
        guard let content = model else { return }
        content.isToggled = toggleSwitch.isOn
        delegate?.didPerformActionToggleContent(withContent: content)
    }
}
