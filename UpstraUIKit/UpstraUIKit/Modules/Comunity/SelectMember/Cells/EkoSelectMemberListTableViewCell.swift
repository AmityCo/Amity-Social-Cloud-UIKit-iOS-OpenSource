//
//  EkoSelectMemberListTableViewCell.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 30/8/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

final class EkoSelectMemberListTableViewCell: UITableViewCell {

    // MARK: - IBOutlet Properties
    @IBOutlet private var avatarView: EkoAvatarView!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var radioImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
   
    override func prepareForReuse() {
        super.prepareForReuse()
        
        displayNameLabel.text = ""
        radioImageView.image = EkoIconSet.iconRadioOff
        radioImageView.isHidden = false
        avatarView.image = nil
        avatarView.placeholder = EkoIconSet.defaultAvatar
    }
    
    private func setupView() {
        
        selectionStyle = .none
        avatarView.isUserInteractionEnabled = false
        displayNameLabel.text = ""
        displayNameLabel.textColor = EkoColorSet.base
        displayNameLabel.font = EkoFontSet.bodyBold
        
        radioImageView.image = EkoIconSet.iconRadioOff
    }
    
    func display(with user: EkoSelectMemberModel) {
        displayNameLabel.text = user.displayName ?? user.defaultDisplayName
        radioImageView.image = user.isSelected ? EkoIconSet.iconRadioCheck : EkoIconSet.iconRadioOff
        radioImageView.isHidden = user.isCurrnetUser
        avatarView.setImage(withImageId: user.avatarId, placeholder: EkoIconSet.defaultAvatar)
    }
    
}
