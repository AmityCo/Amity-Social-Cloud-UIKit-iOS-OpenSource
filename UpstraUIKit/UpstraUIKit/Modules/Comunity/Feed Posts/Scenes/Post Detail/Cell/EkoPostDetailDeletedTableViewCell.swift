//
//  EkoPostDetailDeletedTableViewCell.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 22/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

class EkoPostDetailDeletedTableViewCell: UITableViewCell, Nibbable {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        imageView?.image = EkoIconSet.iconDeleteMessage
        textLabel?.font = EkoFontSet.body
        textLabel?.textColor = EkoColorSet.base.blend(.shade2)
    }
    
    func configure(deletedAt: Date) {
        textLabel?.text = EkoLocalizedStringSet.PostDetail.deletedCommentMessage.localizedString
    }
    
}
