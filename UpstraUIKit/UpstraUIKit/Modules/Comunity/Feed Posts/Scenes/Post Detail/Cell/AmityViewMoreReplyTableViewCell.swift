//
//  AmityViewMoreReplyTableViewCell.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 5/2/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

class AmityViewMoreReplyTableViewCell: UITableViewCell, Nibbable {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        iconImageView.image = AmityIconSet.iconReplyInverse
        titleLabel.text = AmityLocalizedStringSet.PostDetail.viewMoreReply.localizedString
        titleLabel.textColor = AmityColorSet.base.blend(.shade1)
        titleLabel.font = AmityFontSet.captionBold
        containerView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
    }
    
}
