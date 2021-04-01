//
//  EkoSettingsItemToggleContentTableViewCell.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 7/3/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import UIKit

protocol EkoSettingsItemToggleContentCellDelegate: class {
    func didPerformActionToggleContent(withContent content: EkoSettingsItem.ToggleContent)
}

protocol EkoSettingsItemToggleContentCellProtocol {
    func display(content: EkoSettingsItem.ToggleContent)
}

final class EkoSettingsItemToggleContentTableViewCell: UITableViewCell, Nibbable, EkoSettingsItemToggleContentCellProtocol {

    weak var delegate: EkoSettingsItemToggleContentCellDelegate?
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var iconView: EkoIconView!
    @IBOutlet private var titleLabel: EkoLabel!
    @IBOutlet private var descriptionLabel: EkoLabel!
    @IBOutlet private var toggleSwitch: UISwitch!
    
    // MARK: - Properties
    private var model: EkoSettingsItem.ToggleContent?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.image = nil
        titleLabel.text = EkoLocalizedStringSet.titlePlaceholder
        descriptionLabel.text = EkoLocalizedStringSet.descriptionPlaceholder
        toggleSwitch.setOn(false, animated: false)
    }
    
    func display(content: EkoSettingsItem.ToggleContent) {
        model = content
        iconView.image = content.iconContent?.icon
        iconView.isHidden = content.iconContent?.icon == nil

        if let hasBackground = content.iconContent?.hasBackground, hasBackground {
            iconView.backgroundIcon = EkoColorSet.base.blend(.shade4)
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
        backgroundColor = EkoColorSet.backgroundColor
        contentView.backgroundColor = EkoColorSet.backgroundColor
        
        // Title
        titleLabel.text = EkoLocalizedStringSet.titlePlaceholder
        titleLabel.font = EkoFontSet.bodyBold
        titleLabel.textColor = EkoColorSet.base
        
        // Description
        descriptionLabel.text = EkoLocalizedStringSet.descriptionPlaceholder
        descriptionLabel.font = EkoFontSet.caption
        descriptionLabel.textColor = EkoColorSet.base.blend(.shade1)
        descriptionLabel.numberOfLines = 0
        
        // Toggle Switch
        toggleSwitch.onTintColor = EkoColorSet.primary
        toggleSwitch.tintColor = EkoColorSet.base.blend(.shade3)
        toggleSwitch.backgroundColor = EkoColorSet.base.blend(.shade3)
        toggleSwitch.layer.cornerRadius = toggleSwitch.frame.height / 2
    }
  
}

// MARK: - Action
private extension EkoSettingsItemToggleContentTableViewCell {
    @IBAction func toggleValuChanged(_ toggleSwitch: UISwitch) {
        guard let content = model else { return }
        content.isToggled = toggleSwitch.isOn
        delegate?.didPerformActionToggleContent(withContent: content)
    }
}
