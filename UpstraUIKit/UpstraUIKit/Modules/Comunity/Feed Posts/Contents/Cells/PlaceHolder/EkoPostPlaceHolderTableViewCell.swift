//
//  EkoPostPlaceHolderTableViewCell.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/12/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

final class EkoPostPlaceHolderTableViewCell: UITableViewCell, Nibbable {

    // MARK: - IBOutlet Properties
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var heightConstaint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        containerView.backgroundColor = EkoColorSet.backgroundColor
        heightConstaint.constant = UIScreen.main.bounds.width
        setupTitleLabel()
        setupDescriptionLabel()
    }
    
    private func setupTitleLabel() {
        titleLabel.text = EkoLocalizedStringSet.Post.placeholderTitle.localizedString
        titleLabel.textColor = EkoColorSet.base.blend(.shade3)
        titleLabel.font = EkoFontSet.title
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.text = EkoLocalizedStringSet.Post.placeholderDesc.localizedString
        descriptionLabel.textColor = EkoColorSet.base.blend(.shade3)
        descriptionLabel.font = EkoFontSet.caption
    }
}
