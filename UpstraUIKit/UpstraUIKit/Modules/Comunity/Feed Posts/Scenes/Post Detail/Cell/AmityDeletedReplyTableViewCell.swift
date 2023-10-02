//
//  AmityDeletedReplyTableViewCell.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 10/2/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

class AmityDeletedReplyTableViewCell: UITableViewCell, Nibbable {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        iconImageView.image = AmityIconSet.iconDeleteMessage
        titleLabel.text = AmityLocalizedStringSet.PostDetail.deletedReplyMessage.localizedString
        titleLabel.textColor = AmityColorSet.base.blend(.shade2)
        titleLabel.font = AmityFontSet.caption
        containerView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        
    }
    
}
