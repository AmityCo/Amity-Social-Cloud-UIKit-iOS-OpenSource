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

    @IBOutlet weak var avatarView: EkoAvatarView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var badgeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = EkoColorSet.backgroundColor
        contentView.backgroundColor = EkoColorSet.backgroundColor
        titleLabel.font = EkoFontSet.bodyBold
        titleLabel.textColor = EkoColorSet.base
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
        case .community(let community):
            avatarView.setImage(withImageId: community.avatarId, placeholder: EkoIconSet.defaultCommunity)
            titleLabel.text = community.displayName
            badgeImageView.isHidden = !community.isOfficial
        }
    }
    
}
