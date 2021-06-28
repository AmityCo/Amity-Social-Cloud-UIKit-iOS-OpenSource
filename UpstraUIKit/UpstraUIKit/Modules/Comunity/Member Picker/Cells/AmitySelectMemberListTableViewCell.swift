//
//  AmitySelectMemberListTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 30/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

final class AmitySelectMemberListTableViewCell: UITableViewCell {

    // MARK: - IBOutlet Properties
    @IBOutlet private var avatarView: AmityAvatarView!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var radioImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
   
    override func prepareForReuse() {
        super.prepareForReuse()
        
        displayNameLabel.text = ""
        radioImageView.image = AmityIconSet.iconRadioOff
        radioImageView.isHidden = false
        avatarView.image = nil
        avatarView.placeholder = AmityIconSet.defaultAvatar
    }
    
    private func setupView() {
        
        selectionStyle = .none
        avatarView.isUserInteractionEnabled = false
        displayNameLabel.text = ""
        displayNameLabel.textColor = AmityColorSet.base
        displayNameLabel.font = AmityFontSet.bodyBold
        
        radioImageView.image = AmityIconSet.iconRadioOff
    }
    
    func display(with user: AmitySelectMemberModel) {
        displayNameLabel.text = user.displayName ?? user.defaultDisplayName
        radioImageView.image = user.isSelected ? AmityIconSet.iconRadioCheck : AmityIconSet.iconRadioOff
        radioImageView.isHidden = user.isCurrnetUser
        avatarView.setImage(withImageURL: user.avatarURL, placeholder: AmityIconSet.defaultAvatar)
    }
    
}
