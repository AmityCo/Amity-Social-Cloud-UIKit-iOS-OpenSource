//
//  AmityMentionTableViewCell.swift
//  AmityUIKit
//
//  Created by Hamlet on 08.11.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

public final class AmityMentionTableViewCell: UITableViewCell, Nibbable {

    // MARK: - IBOutlet Properties
    @IBOutlet private var avatarView: AmityAvatarView!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var bannedImageView: UIImageView!
    @IBOutlet private var bannedImageViewWidthConstraint: NSLayoutConstraint!
    
    public static let height: CGFloat = 52.0
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        
        displayNameLabel.text = ""
        avatarView.image = nil
        avatarView.placeholder = AmityIconSet.defaultAvatar
        avatarView.alpha = 1
        bannedImageViewWidthConstraint.constant = 0
        bannedImageView.image = nil
        bannedImageView.isHidden = true
    }
    
    public func display(with model: AmityMentionUserModel) {
        avatarView.setImage(withImageURL: model.avatarURL, placeholder: AmityIconSet.defaultAvatar)
        displayNameLabel.text = model.displayName
        
        if model.isGlobalBan {
            displayNameLabel.textColor = AmityColorSet.base.blend(.shade3)
            avatarView.alpha = 0.5
            bannedImageView.isHidden = false
            bannedImageViewWidthConstraint.constant = 16
            bannedImageView.image = AmityIconSet.CommunitySettings.iconCommunitySettingBanned
        } else {
            displayNameLabel.textColor = AmityColorSet.base
            avatarView.alpha = 1
        }
    }
}

// MARK:- Private methods
private extension AmityMentionTableViewCell {
    func setupView() {
        selectionStyle = .none
        backgroundColor = AmityColorSet.backgroundColor
        contentView.backgroundColor = AmityColorSet.backgroundColor
        
        setupAvatarView()
        setupDisplayName()
    }
    
    func setupAvatarView() {
        avatarView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        avatarView.placeholder = AmityIconSet.defaultAvatar
    }
    
    func setupDisplayName() {
        displayNameLabel.text = ""
        displayNameLabel.font = AmityFontSet.bodyBold
        displayNameLabel.textColor = AmityColorSet.base
    }
}
