//
//  EkoDeletedReplyTableViewCell.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 10/2/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import UIKit

class EkoDeletedReplyTableViewCell: UITableViewCell, Nibbable {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        iconImageView.image = EkoIconSet.iconDeleteMessage
        titleLabel.text = EkoLocalizedStringSet.PostDetail.deletedReplyMessage.localizedString
        titleLabel.textColor = EkoColorSet.base.blend(.shade2)
        titleLabel.font = EkoFontSet.caption
        containerView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        
    }
    
}
