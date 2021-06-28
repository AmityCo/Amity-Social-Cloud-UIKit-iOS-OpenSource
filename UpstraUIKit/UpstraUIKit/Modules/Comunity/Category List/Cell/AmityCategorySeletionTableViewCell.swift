//
//  AmityCategorySeletionTableViewCell.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 24/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import AmitySDK
import UIKit

class AmityCategorySeletionTableViewCell: UITableViewCell, Nibbable {

    @IBOutlet private weak var avatarView: AmityAvatarView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var badgeImageView: UIImageView!
    @IBOutlet private weak var checkmarkImageView: UIImageView!
    @IBOutlet private weak var checkmarkTrailingConstraint: NSLayoutConstraint!
    
    private var shouldSelectionEnable: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = AmityColorSet.backgroundColor
        contentView.backgroundColor = AmityColorSet.backgroundColor
        checkmarkImageView.image = AmityIconSet.iconCheckMark
        checkmarkImageView.tintColor = AmityColorSet.primary
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
    
    func configure(category: AmityCommunityCategory, shouldSelectionEnable: Bool) {
        titleLabel.text = category.name
        avatarView.setImage(withImageURL: category.avatar?.fileURL ?? "", placeholder: AmityIconSet.defaultCategory)
        self.shouldSelectionEnable = shouldSelectionEnable
        checkmarkTrailingConstraint.constant = shouldSelectionEnable ? 38 : 8
    }
    
}
