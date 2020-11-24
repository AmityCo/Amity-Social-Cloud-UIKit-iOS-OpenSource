//
//  EkoCategorySeletionTableViewCell.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 24/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import EkoChat
import UIKit

class EkoCategorySeletionTableViewCell: UITableViewCell, Nibbable {

    @IBOutlet private weak var avatarView: EkoAvatarView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var badgeImageView: UIImageView!
    @IBOutlet private weak var checkmarkImageView: UIImageView!
    @IBOutlet private weak var checkmarkTrailingConstraint: NSLayoutConstraint!
    
    private var shouldSelectionEnable: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = EkoColorSet.backgroundColor
        contentView.backgroundColor = EkoColorSet.backgroundColor
        checkmarkImageView.image = EkoIconSet.iconCheckMark
        checkmarkImageView.tintColor = EkoColorSet.primary
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        avatarView.image = nil
        shouldSelectionEnable = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkmarkImageView.isHidden = shouldSelectionEnable ? !selected : true
    }
    
    func configure(category: EkoCommunityCategory, shouldSelectionEnable: Bool) {
        titleLabel.text = category.name
        avatarView.setImage(withImageId: category.avatarFileId, placeholder: EkoIconSet.defaultCategory)
        self.shouldSelectionEnable = shouldSelectionEnable
        checkmarkTrailingConstraint.constant = shouldSelectionEnable ? 38 : 8
    }
    
}
