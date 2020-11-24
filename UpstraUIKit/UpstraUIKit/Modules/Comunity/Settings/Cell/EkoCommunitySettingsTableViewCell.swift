//
//  EkoCommunitySettingsTableViewCell.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 14/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

final class EkoCommunitySettingsTableViewCell: UITableViewCell, Nibbable {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var indicatorImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func display(with model: EkoCommunitySettingsModel) {
        titleLabel.text = model.title
        iconImageView.image = model.icon
        titleLabel.textColor = model.isLast ? EkoColorSet.alert : EkoColorSet.base
        indicatorImageView.isHidden = model.isLast
        iconImageView.isHidden = model.isLast
    }
}

// MARK: - Setup view
private extension EkoCommunitySettingsTableViewCell {
    func setupView() {
        selectionStyle = .none
        backgroundColor = EkoColorSet.backgroundColor
        contentView.backgroundColor = EkoColorSet.backgroundColor
        setupTitleLabel()
        setupIconImageView()
    }
    
    func setupTitleLabel() {
        titleLabel.text = ""
        titleLabel.font = EkoFontSet.body
        titleLabel.textColor = EkoColorSet.base
    }
    
    func setupIconImageView() {
        iconImageView.image = nil
        iconImageView.tintColor = EkoColorSet.base
    }
}
