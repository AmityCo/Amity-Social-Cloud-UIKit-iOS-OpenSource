//
//  EkoTrendingCommunityTableViewCell.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 6/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

final class EkoTrendingCommunityTableViewCell: UITableViewCell, Nibbable {

    @IBOutlet private var avatarView: EkoAvatarView!
    @IBOutlet private var numberLabel: UILabel!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var membersLabel: UILabel!
    @IBOutlet private weak var iconImageViewWidthConstraint: NSLayoutConstraint!
    
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
        iconImageView.image = nil
        categoryLabel.text = nil
        numberLabel.text = nil
        membersLabel.text = nil
    }
    
    func display(with model: EkoCommunityModel) {
        avatarView.setImage(withImageId: model.avatarId, placeholder: EkoIconSet.defaultCommunity)
        displayNameLabel.text = model.displayName
        categoryLabel.text = model.category
        
        membersLabel.text = String.localizedStringWithFormat(EkoLocalizedStringSet.trendingCommunityMembers.localizedString, model.membersCount.formatUsingAbbrevation())
        iconImageView.isHidden = !model.isOfficial
        iconImageViewWidthConstraint.constant = !model.isOfficial ? 0 : 24
    }
    
    func displayNumber(with indexPath: IndexPath) {
        numberLabel.text = "\(indexPath.row + 1)"
    }
}

// MARK: - Setup View
private extension EkoTrendingCommunityTableViewCell {
    func setupView() {
        selectionStyle = .none
        setupAvatarView()
        setupNumber()
        setupDisplayName()
        setupMetadata()
    }
    
    func setupAvatarView() {
        avatarView.placeholder = EkoIconSet.defaultCommunity
        avatarView.backgroundColor = EkoColorSet.secondary.blend(.shade3)
    }
    
    func setupNumber() {
        numberLabel.text = ""
        numberLabel.textColor = EkoColorSet.highlight
        numberLabel.font = EkoFontSet.title
    }
    
    func setupDisplayName() {
        displayNameLabel.text = ""
        displayNameLabel.textColor = EkoColorSet.base
        displayNameLabel.font = EkoFontSet.title
        
        iconImageView.image = EkoIconSet.iconBadgeCheckmark
        iconImageView.tintColor = EkoColorSet.highlight
        iconImageView.isHidden = true
        iconImageViewWidthConstraint.constant = 0
    }
    
    func setupMetadata() {
        categoryLabel.text = ""
        categoryLabel.textColor = EkoColorSet.base.blend(.shade1)
        categoryLabel.font = EkoFontSet.caption
        
        membersLabel.text = ""
        membersLabel.textColor = EkoColorSet.base.blend(.shade1)
        membersLabel.font = EkoFontSet.caption
    }
}
