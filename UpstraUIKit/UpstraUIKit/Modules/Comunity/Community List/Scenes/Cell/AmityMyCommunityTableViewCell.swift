//
//  AmityMyCommunityTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 22/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityMyCommunityTableViewCellDelegate: AnyObject {
    func cellDidTapOnAvatar(_ cell: AmityMyCommunityTableViewCell)
}

final class AmityMyCommunityTableViewCell: UITableViewCell, Nibbable {
    
    static let defaultHeight: CGFloat = 56.0
    
    weak var delegate: AmityMyCommunityTableViewCellDelegate?
    
    @IBOutlet private var avatarView: AmityAvatarView!
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
        
        setupAvatarView()
        
        displayNameLabel.font = AmityFontSet.bodyBold
        displayNameLabel.textColor = AmityColorSet.base
        displayNameLabel.text = ""
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
        avatarView.image = nil
        badgeImageView.isHidden = true
        privateBadgeImageView.isHidden = true
    }
    
    func display(with community: AmityCommunityModel) {
        avatarView.setImage(withImageURL: community.avatarURL, placeholder: AmityIconSet.defaultCommunity)
        displayNameLabel.text = community.displayName
        badgeImageView.isHidden = !community.isOfficial
        privateBadgeImageView.isHidden = community.isPublic
    }
}

// MARK:- Actions
private extension AmityMyCommunityTableViewCell {
    func avatarTap() {
        delegate?.cellDidTapOnAvatar(self)
    }
}
