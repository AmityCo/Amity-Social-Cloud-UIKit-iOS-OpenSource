//
//  AmityReactionUserTableViewCell.swift
//  AmityUIKit
//
//  Created by Amity on 26/4/2566 BE.
//  Copyright © 2566 BE Amity. All rights reserved.
//

import UIKit

class AmityReactionUserTableViewCell: UITableViewCell, Nibbable {

    @IBOutlet private weak var userAvatarView: AmityAvatarView!
    @IBOutlet private weak var displayNameLabel: UILabel!
    
    public var avatarTapAction: (() -> Void)?
    
    let skeletonLayer = CALayer()
    var layerName = "ReactionSkeletonLayer"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }
    
    func setupViews() {
        selectionStyle = .none

        displayNameLabel.font = AmityFontSet.bodyBold
        displayNameLabel.textColor = AmityColorSet.base
    }
    
    func display(with model: ReactionUser) {
        displayNameLabel.text = model.displayName
        userAvatarView.setImage(withImageURL: model.avatarURL, placeholder: AmityIconSet.defaultAvatar)
        userAvatarView.actionHandler = avatarTapAction
    }
}
