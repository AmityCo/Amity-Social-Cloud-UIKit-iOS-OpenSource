//
//  EkoCategoryDetailTableViewCell.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 15/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

class EkoCategoryCommunityListTableViewCell: UITableViewCell, Nibbable {
    
    static let defaultHeight: CGFloat = 56.0

    @IBOutlet private weak var avatarView: EkoAvatarView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var badgeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = EkoColorSet.backgroundColor
        contentView.backgroundColor = EkoColorSet.backgroundColor
        titleLabel.font = EkoFontSet.bodyBold
        titleLabel.textColor = EkoColorSet.base
        badgeImageView.image = EkoIconSet.iconBadgeCheckmark
        badgeImageView.tintColor = EkoColorSet.highlight
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        avatarView.image = nil
        badgeImageView.isHidden = true
    }
    
    func configure(community: EkoCommunityModel) {
        titleLabel.text = community.displayName
        avatarView.setImage(withImageId: community.avatarId, placeholder: EkoIconSet.defaultCommunity)
        badgeImageView.isHidden = !community.isOfficial
    }
    
}
