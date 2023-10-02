//
//  AmityTrendingCommunityTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 6/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

protocol AmityTrendingCommunityTableViewCellDelegate: AnyObject {
    func cellDidTapOnAvatar(_ cell: AmityTrendingCommunityTableViewCell)
}

final class AmityTrendingCommunityTableViewCell: UITableViewCell, Nibbable {

    @IBOutlet private var avatarView: AmityAvatarView!
    @IBOutlet private var numberLabel: UILabel!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var membersLabel: UILabel!
    @IBOutlet private var iconImageViewWidthConstraint: NSLayoutConstraint!
    
    weak var delegate: AmityTrendingCommunityTableViewCellDelegate?
    
    var isCategoryLabelTruncated: Bool {
        return categoryLabel.isTruncated
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.image = nil
        displayNameLabel.text = nil
        categoryLabel.text = nil
        numberLabel.text = nil
        membersLabel.text = nil
    }
    
    func display(with model: AmityCommunityModel) {
        avatarView.setImage(withImageURL: model.avatarURL, placeholder: AmityIconSet.defaultCommunity)
        displayNameLabel.text = model.displayName
        categoryLabel.text = model.category
        
        membersLabel.text = String.localizedStringWithFormat(AmityLocalizedStringSet.trendingCommunityMembers.localizedString, model.membersCount.formatUsingAbbrevation())
        iconImageView.isHidden = !model.isOfficial
        iconImageViewWidthConstraint.constant = !model.isOfficial ? 0 : 24
    }
    
    func displayNumber(with indexPath: IndexPath) {
        numberLabel.text = "\(indexPath.row + 1)"
    }
}

// MARK: - Setup View
private extension AmityTrendingCommunityTableViewCell {
    func setupView() {
        selectionStyle = .none
        setupAvatarView()
        setupNumber()
        setupDisplayName()
        setupMetadata()
    }
    
    func setupAvatarView() {
        avatarView.placeholderPostion = .fullSize
        avatarView.placeholder = AmityIconSet.defaultCommunity
        avatarView.contentMode = .scaleAspectFill
        
        avatarView.actionHandler = { [weak self] in
            self?.avatarTap()
        }
    }
    
    func setupNumber() {
        numberLabel.text = ""
        numberLabel.textColor = AmityColorSet.highlight
        numberLabel.font = AmityFontSet.title
    }
    
    func setupDisplayName() {
        displayNameLabel.text = ""
        displayNameLabel.textColor = AmityColorSet.base
        displayNameLabel.font = AmityFontSet.title
        
        iconImageView.image = AmityIconSet.iconBadgeCheckmark
        iconImageView.tintColor = AmityColorSet.highlight
        iconImageView.isHidden = true
        iconImageViewWidthConstraint.constant = 0
    }
    
    func setupMetadata() {
        categoryLabel.text = ""
        categoryLabel.textColor = AmityColorSet.base.blend(.shade1)
        categoryLabel.font = AmityFontSet.caption
        
        membersLabel.text = ""
        membersLabel.textColor = AmityColorSet.base.blend(.shade1)
        membersLabel.font = AmityFontSet.caption
    }
}

// MARK:- Actions
private extension AmityTrendingCommunityTableViewCell {
    func avatarTap() {
        delegate?.cellDidTapOnAvatar(self)
    }
}
