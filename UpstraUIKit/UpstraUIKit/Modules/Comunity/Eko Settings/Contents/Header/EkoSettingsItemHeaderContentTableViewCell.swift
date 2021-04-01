//
//  EkoSettingsItemHeaderContentTableViewCell.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 7/3/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import UIKit

protocol EkoSettingsItemHeaderCellProtocol {
    func display(content: EkoSettingsItem.HeaderContent)
}

final class EkoSettingsItemHeaderContentTableViewCell: UITableViewCell, Nibbable, EkoSettingsItemHeaderCellProtocol {

    // MARK: - IBOutlet Properties
    @IBOutlet private var titleLabel: EkoLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = EkoLocalizedStringSet.titlePlaceholder
    }
    
    func display(content: EkoSettingsItem.HeaderContent) {
        titleLabel.text = content.title
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = EkoColorSet.backgroundColor
        contentView.backgroundColor = EkoColorSet.backgroundColor
        
        // MARK: - Title
        titleLabel.text = EkoLocalizedStringSet.titlePlaceholder
        titleLabel.font = EkoFontSet.title
        titleLabel.textColor = EkoColorSet.base
    }
}
