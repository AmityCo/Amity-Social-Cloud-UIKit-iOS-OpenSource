//
//  AmityFollowingRecentChatCollectionViewCell.swift
//  AmityUIKit
//
//  Created by Jiratin Teean on 3/8/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import UIKit

class AmityFollowingRecentChatCollectionViewCell: UICollectionViewCell, Nibbable {
    
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var avatarView: AmityAvatarView!
    @IBOutlet private var displayNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        displayNameLabel.text = ""
        avatarView.image = nil
    }
    
    private func setupView() {
        containerView.backgroundColor = AmityColorSet.backgroundColor
        avatarView.placeholderPostion = .fullSize
        avatarView.placeholder = AmityIconSet.defaultCommunity
        avatarView.contentMode = .scaleAspectFit
        avatarView.isUserInteractionEnabled = false
        displayNameLabel.text = ""
        displayNameLabel.textAlignment = .center
        displayNameLabel.font = AmityFontSet.caption
        displayNameLabel.textColor = AmityColorSet.base
        displayNameLabel.numberOfLines = 2
    }
    
    func display(with value: AmityUserModel) {
        displayNameLabel.text = value.displayName
        avatarView.contentMode = .scaleAspectFit
        if !value.avatarCustomURL.isEmpty {
            avatarView.setImage(withCustomURL: value.avatarCustomURL, placeholder: AmityIconSet.defaultCommunity)
        } else {
            avatarView.setImage(withCustomURL: value.avatarURL, placeholder: AmityIconSet.defaultCommunity)
        }
    }
    
    func displayDummy() {
        displayNameLabel.text = AmityLocalizedStringSet.RecentMessage.discoveryFriendsMessage.localizedString
        avatarView.contentMode = .center
        avatarView.image = AmityIconSet.Chat.iconCommunityRecent
    }
}
