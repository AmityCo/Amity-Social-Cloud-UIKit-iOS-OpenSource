//
//  AmityMessageImageIncomingTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 4/12/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit

final class AmityMessageImageIncomingTableViewCell: AmityMessageImageTableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func display(message: AmityMessageModel) {
        super.display(message: message)
    }
    
    override class func height(for message: AmityMessageModel, boundingWidth: CGFloat) -> CGFloat {
        let displaynameHeight: CGFloat = 22
        if message.isDeleted {
            return AmityMessageTableViewCell.deletedMessageCellHeight + displaynameHeight
        }
        return 180 + displaynameHeight
    }
    
}
