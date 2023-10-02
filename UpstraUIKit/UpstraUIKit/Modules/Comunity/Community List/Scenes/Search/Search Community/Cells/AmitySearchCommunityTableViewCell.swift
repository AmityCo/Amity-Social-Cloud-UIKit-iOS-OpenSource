//
//  AmitySearchCommunityTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 22/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmitySearchCommunityTableViewCellDelegate: AnyObject {
    func cellDidTapOnAvatar(_ cell: AmitySearchCommunityTableViewCell)
}

final class AmitySearchCommunityTableViewCell: UITableViewCell, Nibbable {
    
    static let defaultHeight: CGFloat = 56.0
    
    weak var delegate: AmitySearchCommunityTableViewCellDelegate?
    
    @IBOutlet private var avatarView: AmityAvatarView!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var privateBadgeImageView: UIImageView!
    @IBOutlet private var badgeImageView: UIImageView!
    @IBOutlet private var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        setupAvatarView()
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        displayNameLabel.font = AmityFontSet.bodyBold
        displayNameLabel.textColor = AmityColorSet.base
        displayNameLabel.text = ""
        categoryLabel.font = AmityFontSet.caption
        categoryLabel.textColor = AmityColorSet.base.blend(.shade1)
        categoryLabel.text = ""
        privateBadgeImageView.image = AmityIconSet.iconPrivate
        privateBadgeImageView.tintColor = AmityColorSet.base
        badgeImageView.image = AmityIconSet.iconBadgeCheckmark
        badgeImageView.tintColor = AmityColorSet.highlight
    }
    
    func setupAvatarView() {
        avatarView.placeholderPostion = .fullSize
        avatarView.placeholder = AmityIconSet.defaultCommunity
        avatarView.contentMode = .scaleAspectFill
        avatarView.actionHandler = { [weak self] in
            self?.avatarTap()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.placeholder = AmityIconSet.defaultCommunity
        displayNameLabel.text = ""
        categoryLabel.text = ""
        avatarView.image = nil
        badgeImageView.isHidden = true
        privateBadgeImageView.isHidden = true
    }
    
    func display(with community: AmityCommunityModel) {
        avatarView.setImage(withImageURL: community.avatarURL, placeholder: AmityIconSet.defaultCommunity)
        displayNameLabel.text = community.displayName
        categoryLabel.text = community.category
        badgeImageView.isHidden = !community.isOfficial
        privateBadgeImageView.isHidden = community.isPublic
    }
}

// MARK:- Actions
private extension AmitySearchCommunityTableViewCell {
    func avatarTap() {
        delegate?.cellDidTapOnAvatar(self)
    }
}
