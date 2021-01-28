//
//  EkoMyCommunityCollectionViewCell.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 24/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

final class EkoMyCommunityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var avatarView: EkoAvatarView!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var badgeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        displayNameLabel.text = ""
        avatarView.placeholder = EkoIconSet.defaultCommunity
        avatarView.image = nil
    }
    
    private func setupView() {
        containerView.backgroundColor = EkoColorSet.backgroundColor
        avatarView.placeholder = EkoIconSet.defaultCommunity
        avatarView.isUserInteractionEnabled = false
        displayNameLabel.text = ""
        displayNameLabel.textAlignment = .center
        displayNameLabel.font = EkoFontSet.caption
        displayNameLabel.textColor = EkoColorSet.base
        badgeImageView.image = EkoIconSet.iconBadgeCheckmark
        badgeImageView.tintColor = EkoColorSet.highlight
    }
    
    func display(with community: EkoCommunityModel) {
        displayNameLabel.text = community.displayName
        avatarView.setImage(withImageId: community.avatarId, placeholder: EkoIconSet.defaultCommunity)
        avatarView.backgroundColor = EkoColorSet.primary.blend(.shade3)
        badgeImageView.isHidden = !community.isOfficial
    }
    
    func seeAll() {
        displayNameLabel.text = EkoLocalizedStringSet.myCommunitySeeAll.localizedString
        avatarView.image = nil
        avatarView.placeholder = EkoIconSet.iconArrowRight
        avatarView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        
    }

}
