//
//  EkoCommunityTableViewCell.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 31/7/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import EkoChat
import UIKit

enum CommunityCellType {
    case myFeed
    case community(EkoCommunityModel)
}

class EkoCommunityTableViewCell: UITableViewCell, Nibbable {
    
    static let defaultHeight: CGFloat = 56

    @IBOutlet private weak var avatarView: EkoAvatarView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var badgeImageView: UIImageView!
    @IBOutlet private weak var privateBadgeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = EkoColorSet.backgroundColor
        contentView.backgroundColor = EkoColorSet.backgroundColor
        titleLabel.font = EkoFontSet.bodyBold
        titleLabel.textColor = EkoColorSet.base
        privateBadgeImageView.image = EkoIconSet.iconPrivate
        privateBadgeImageView.tintColor = EkoColorSet.base
        badgeImageView.image = EkoIconSet.iconBadgeCheckmark
        badgeImageView.tintColor = EkoColorSet.highlight
        badgeImageView.isHidden = true
    }
    
    func configure(with type: CommunityCellType) {
        switch type {
        case .myFeed:
            avatarView.setImage(withImageId: UpstraUIKitManagerInternal.shared.client.currentUser?.object?.avatarFileId ?? "", placeholder: EkoIconSet.defaultAvatar)
            titleLabel.text = EkoLocalizedStringSet.postCreationMyTimelineTitle.localizedString
            badgeImageView.isHidden = false
            privateBadgeImageView.isHidden = true
        case .community(let community):
            avatarView.setImage(withImageId: community.avatarId, placeholder: EkoIconSet.defaultCommunity)
            titleLabel.text = community.displayName
            badgeImageView.isHidden = !community.isOfficial
            privateBadgeImageView.isHidden = community.isPublic
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.placeholder = EkoIconSet.defaultCommunity
        titleLabel.text = ""
        avatarView.image = nil
        badgeImageView.isHidden = true
        privateBadgeImageView.isHidden = true
    }
}
