//
//  EkoViewMoreReplyTableViewCell.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 5/2/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import UIKit

class EkoViewMoreReplyTableViewCell: UITableViewCell, Nibbable {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        iconImageView.image = EkoIconSet.iconReplyInverse
        titleLabel.text = EkoLocalizedStringSet.PostDetail.viewMoreReply.localizedString
        titleLabel.textColor = EkoColorSet.base.blend(.shade1)
        titleLabel.font = EkoFontSet.captionBold
        containerView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
    }
    
}
