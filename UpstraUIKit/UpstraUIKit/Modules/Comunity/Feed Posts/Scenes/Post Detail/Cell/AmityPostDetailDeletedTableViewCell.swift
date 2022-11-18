//
//  AmityPostDetailDeletedTableViewCell.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 22/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

class AmityPostDetailDeletedTableViewCell: UITableViewCell, Nibbable {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        imageView?.image = AmityIconSet.iconDeleteMessage
        textLabel?.font = AmityFontSet.body
        textLabel?.textColor = AmityColorSet.base.blend(.shade2)
    }
    
    func configure(deletedAt: Date) {
        textLabel?.text = AmityLocalizedStringSet.PostDetail.deletedCommentMessage.localizedString
    }
    
    static var height: CGFloat {
        return 44
    }
    
}
