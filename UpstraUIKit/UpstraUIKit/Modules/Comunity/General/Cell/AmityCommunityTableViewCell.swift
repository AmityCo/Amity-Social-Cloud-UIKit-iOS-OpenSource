//
//  AmityCommunityTableViewCell.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 31/7/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import AmitySDK
import UIKit

enum CommunityCellType {
    case myFeed
    case community(AmityCommunityModel)
}

class AmityCommunityTableViewCell: UITableViewCell, Nibbable {
    
    static let defaultHeight: CGFloat = 56

    @IBOutlet private weak var avatarView: AmityAvatarView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var badgeImageView: UIImageView!
    @IBOutlet private weak var privateBadgeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = AmityColorSet.backgroundColor
        contentView.backgroundColor = AmityColorSet.backgroundColor
        titleLabel.font = AmityFontSet.bodyBold
        titleLabel.textColor = AmityColorSet.base
        privateBadgeImageView.image = AmityIconSet.iconPrivate
        privateBadgeImageView.tintColor = AmityColorSet.base
        badgeImageView.image = AmityIconSet.iconBadgeCheckmark
        badgeImageView.tintColor = AmityColorSet.highlight
        badgeImageView.isHidden = true
    }
    
    func configure(with type: CommunityCellType) {
        switch type {
        case .myFeed:
            avatarView.setImage(withImageURL: AmityUIKitManagerInternal.shared.client.currentUser?.object?.getAvatarInfo()?.fileURL ?? "", placeholder: AmityIconSet.defaultAvatar)
            avatarView.placeholderPostion = .center
            titleLabel.text = AmityLocalizedStringSet.postCreationMyTimelineTitle.localizedString
            badgeImageView.isHidden = true
            privateBadgeImageView.isHidden = true
        case .community(let community):
            avatarView.setImage(withImageURL: community.avatarURL, placeholder: AmityIconSet.defaultCommunity)
            avatarView.placeholderPostion = .fullSize
            titleLabel.text = community.displayName
            badgeImageView.isHidden = !community.isOfficial
            privateBadgeImageView.isHidden = community.isPublic
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.placeholderPostion = .fullSize
        avatarView.placeholder = AmityIconSet.defaultCommunity
        avatarView.contentMode = .scaleAspectFill
        titleLabel.text = ""
        avatarView.image = nil
        badgeImageView.isHidden = true
        privateBadgeImageView.isHidden = true
    }
}
