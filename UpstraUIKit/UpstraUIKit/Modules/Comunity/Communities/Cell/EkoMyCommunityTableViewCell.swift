//
//  EkoMyCommunityTableViewCell.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 22/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoMyCommunityTableViewCell: UITableViewCell, Nibbable {
    
    @IBOutlet private var avatarView: EkoAvatarView!
    @IBOutlet private var displayNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        avatarView.placeholder = EkoIconSet.defaultCommunity
        avatarView.isUserInteractionEnabled = false
        
        displayNameLabel.font = EkoFontSet.bodyBold
        displayNameLabel.textColor = EkoColorSet.base
        displayNameLabel.text = ""
        displayNameLabel.isUserInteractionEnabled = false
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.placeholder = EkoIconSet.defaultCommunity
        displayNameLabel.text = ""
        avatarView.image = nil
    }
    
    func display(with community: EkoCommunityModel) {
        avatarView.setImage(withImageId: community.avatarId, placeholder: EkoIconSet.defaultCommunity)
        displayNameLabel.text = community.displayName
        displayNameLabel.setImageWithText(position: .both(imageLeft: community.isPublic ? nil:EkoIconSet.iconPrivate, imageRight: community.isOfficial ? EkoIconSet.iconBadgeCheckmark:nil))
    }
}
