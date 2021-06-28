//
//  AmityKeyboardComposeBarCollectionViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 26/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

final class AmityKeyboardComposeBarCollectionViewCell: UICollectionViewCell, Nibbable {

    @IBOutlet private var containerBackgroundView: UIView!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        nameLabel.text = ""
    }
    
    func display(with model: AmityKeyboardComposeBarModel) {
        iconImageView.image = model.image
        nameLabel.text = model.name
    }
}

private extension AmityKeyboardComposeBarCollectionViewCell {
    func setupView() {
        containerBackgroundView.backgroundColor = UIColor.white
        containerView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        containerView.layer.cornerRadius = containerView.frame.height / 2
        
        nameLabel.text = ""
        nameLabel.textColor = AmityColorSet.base.blend(.shade1)
        nameLabel.font = AmityFontSet.caption
    }
}
