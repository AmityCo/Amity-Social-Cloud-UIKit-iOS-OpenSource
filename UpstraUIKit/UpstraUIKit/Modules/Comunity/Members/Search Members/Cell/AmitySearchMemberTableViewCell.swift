//
//  AmitySearchMemberTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 22/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmitySearchMemberTableViewCellDelegate: AnyObject {
    func cellDidTapOnAvatar(_ cell: AmitySearchMemberTableViewCell)
}

final class AmitySearchMemberTableViewCell: UITableViewCell, Nibbable {
    
    static let defaultHeight: CGFloat = 56.0
    
    weak var delegate: AmitySearchMemberTableViewCellDelegate?
    
    @IBOutlet private var avatarView: AmityAvatarView!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var bannedImageView: UIImageView!
    @IBOutlet private var bannedImageViewWidthConstraint: NSLayoutConstraint!
    
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
    }
    
    func setupAvatarView() {
        avatarView.placeholder = AmityIconSet.defaultAvatar
        avatarView.actionHandler = { [weak self] in
            self?.avatarTap()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.placeholder = AmityIconSet.defaultAvatar
        displayNameLabel.text = ""
        avatarView.image = nil
        bannedImageViewWidthConstraint.constant = 0
        bannedImageView.image = nil
        bannedImageView.isHidden = true
    }
    
    func display(with user: AmityUserModel) {
        avatarView.setImage(withImageURL: user.avatarURL, placeholder: AmityIconSet.defaultAvatar)
        displayNameLabel.text = user.displayName
        
        if user.isGlobalBan {
            bannedImageView.isHidden = false
            bannedImageViewWidthConstraint.constant = 16
            bannedImageView.image = AmityIconSet.CommunitySettings.iconCommunitySettingBanned
        }
    }
}

// MARK:- Actions
private extension AmitySearchMemberTableViewCell {
    func avatarTap() {
        delegate?.cellDidTapOnAvatar(self)
    }
}
