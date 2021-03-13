//
//  EkoMyCommunityTableViewCell.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 22/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoMyCommunityTableViewCell: UITableViewCell, Nibbable {
    
    static let defaultHeight: CGFloat = 56.0
    
    @IBOutlet private var avatarView: EkoAvatarView!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var privateBadgeImageView: UIImageView!
    @IBOutlet private var badgeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        avatarView.placeholder = EkoIconSet.defaultCommunity
        displayNameLabel.font = EkoFontSet.bodyBold
        displayNameLabel.textColor = EkoColorSet.base
        displayNameLabel.text = ""
        privateBadgeImageView.image = EkoIconSet.iconPrivate
        privateBadgeImageView.tintColor = EkoColorSet.base
        badgeImageView.image = EkoIconSet.iconBadgeCheckmark
        badgeImageView.tintColor = EkoColorSet.highlight
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.placeholder = EkoIconSet.defaultCommunity
        displayNameLabel.text = ""
        avatarView.image = nil
        badgeImageView.isHidden = true
        privateBadgeImageView.isHidden = true
    }
    
    func display(with community: EkoCommunityModel) {
        avatarView.setImage(withImageId: community.avatarId, placeholder: EkoIconSet.defaultCommunity)
        displayNameLabel.text = community.displayName
        badgeImageView.isHidden = !community.isOfficial
        privateBadgeImageView.isHidden = community.isPublic
    }
}
