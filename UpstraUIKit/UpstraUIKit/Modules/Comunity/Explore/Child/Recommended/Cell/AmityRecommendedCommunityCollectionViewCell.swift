//
//  AmityRecommendedCommunityCollectionViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 6/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

protocol AmityRecommendedCommunityCollectionViewCellDelegate: AnyObject {
    func cellDidTapOnAvatar(_ cell: AmityRecommendedCommunityCollectionViewCell)
}


final class AmityRecommendedCommunityCollectionViewCell: UICollectionViewCell, Nibbable {

    weak var delegate: AmityRecommendedCommunityCollectionViewCellDelegate?
    
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var avatarView: AmityAvatarView!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var badgeImageView: UIImageView!
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var memberLabel: UILabel!
    @IBOutlet private var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.image = nil
        displayNameLabel.text = nil
        badgeImageView.isHidden = true
        categoryLabel.text = nil
        memberLabel.text = nil
        descLabel.text = nil
    }
    
    func display(with model: AmityCommunityModel) {
        avatarView.setImage(withImageURL: model.avatarURL, placeholder: AmityIconSet.defaultCommunity)
        displayNameLabel.text = model.displayName
        categoryLabel.text = model.category
        
        let memberCountPrefix = model.membersCount == 1 ? AmityLocalizedStringSet.Unit.memberSingular.localizedString : AmityLocalizedStringSet.Unit.memberPlural.localizedString
        memberLabel.text = String.localizedStringWithFormat(memberCountPrefix, model.membersCount.formatUsingAbbrevation())
        descLabel.text = model.description == "" ? "-" : model.description
        badgeImageView.isHidden = !model.isOfficial
    }
}

// MARK: - Setup view
private extension AmityRecommendedCommunityCollectionViewCell {
    func setupView() {
        setupContainerView()
        setupAvatarView()
        setupBadge()
        setupDisplayName()
        setupCategory()
        setupMember()
        setupDesc()
    }
    
    func setupContainerView() {
        containerView.layer.cornerRadius = 4
    }
    
    func setupAvatarView() {
        avatarView.placeholderPostion = .fullSize
        avatarView.placeholder = AmityIconSet.defaultCommunity
        avatarView.contentMode = .scaleAspectFill
        avatarView.actionHandler = { [weak self] in
            self?.avatarTap()
        }
    }
    
    func setupDisplayName() {
        displayNameLabel.text = ""
        displayNameLabel.textColor = AmityColorSet.base
        displayNameLabel.font = AmityFontSet.bodyBold
    }
    
    func setupBadge() {
        badgeImageView.image = AmityIconSet.iconBadgeCheckmark
        badgeImageView.tintColor = AmityColorSet.highlight
        badgeImageView.isHidden = true
    }
    
    func setupCategory() {
        categoryLabel.text = ""
        categoryLabel.textColor = AmityColorSet.base.blend(.shade1)
        categoryLabel.font = AmityFontSet.caption
    }
    
    func setupMember() {
        memberLabel.text = ""
        memberLabel.textColor = AmityColorSet.base.blend(.shade1)
        memberLabel.font = AmityFontSet.caption
    }
    
    func setupDesc() {
        descLabel.text = ""
        descLabel.textColor = AmityColorSet.base
        descLabel.font = AmityFontSet.caption
        descLabel.numberOfLines = 3
    }
}

// MARK:- Actions
private extension AmityRecommendedCommunityCollectionViewCell {
    func avatarTap() {
        delegate?.cellDidTapOnAvatar(self)
    }
}
