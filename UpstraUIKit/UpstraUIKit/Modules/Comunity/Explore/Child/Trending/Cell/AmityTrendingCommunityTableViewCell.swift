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
    func didJoin(with item: AmityCommunityModel)
    func didLeave(with item: AmityCommunityModel)
}

final class AmityTrendingCommunityTableViewCell: UITableViewCell, Nibbable {

    @IBOutlet private var avatarView: AmityAvatarView!
    @IBOutlet private var numberLabel: UILabel!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var joinButton: UIButton!
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var membersLabel: UILabel!
    @IBOutlet private var iconImageViewWidthConstraint: NSLayoutConstraint!
    
    weak var delegate: AmityTrendingCommunityTableViewCellDelegate?
    var item: AmityCommunityModel?
    
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
        self.item = model
        avatarView.setImage(withImageURL: model.avatarURL, placeholder: AmityIconSet.defaultCommunity)
        displayNameLabel.text = model.displayName
        categoryLabel.text = model.category
        membersLabel.text = String.localizedStringWithFormat(AmityLocalizedStringSet.trendingCommunityMembers.localizedString, model.membersCount.formatUsingAbbrevation())
        iconImageView.isHidden = !model.isOfficial
        iconImageViewWidthConstraint.constant = !model.isOfficial ? 0 : 24
        
        let joinButtonTitle = model.isJoined ? AmityLocalizedStringSet.communityDetailJoinedButton.localizedString : AmityLocalizedStringSet.communityDetailJoinButton.localizedString
        
        if model.isJoined {
            joinButton.setTitle(joinButtonTitle, for: .normal)
            joinButton.setTitleColor(AmityColorSet.primary, for: .normal)
            joinButton.setBackgroundColor(color: .white, forState: .normal)
            joinButton.layer.borderWidth = 1.0
            joinButton.layer.borderColor = AmityColorSet.primary.cgColor
        } else {
            joinButton.setTitle(joinButtonTitle, for: .normal)
            joinButton.setTitleColor(.white, for: .normal)
            joinButton.setBackgroundColor(color: AmityColorSet.primary, forState: .normal)
            joinButton.layer.borderWidth = 1.0
            joinButton.layer.borderColor = AmityColorSet.primary.cgColor
        }
    }
    
    func displayNumber(with indexPath: IndexPath) {
        numberLabel.text = "\(indexPath.row + 1)"
    }
    
    
    @IBAction func joinButtonTapped(_ sender: Any) {
        guard let item = self.item else { return }
        if item.isJoined {
            delegate?.didLeave(with: item)
        } else {
            let commuExternal = AmityCommunityModelExternal(object: item)
            AmityEventHandler.shared.communityJoinButtonTracking(screenName: ScreenName.explore.rawValue, communityModel: commuExternal)
            delegate?.didJoin(with: item)
        }
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
        setupJoinButton()
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
    
    func setupJoinButton() {
        joinButton.setTitle("", for: .normal)
        joinButton.layer.cornerRadius = joinButton.frame.height / 2
        joinButton.layer.masksToBounds = true
        joinButton.sizeToFit()
        joinButton.titleLabel?.font = AmityFontSet.captionBold
    }
}

// MARK:- Actions
private extension AmityTrendingCommunityTableViewCell {
    func avatarTap() {
        delegate?.cellDidTapOnAvatar(self)
    }
}
