//
//  CustomMessageTextIncomingTableViewCell.swift
//  SampleApp
//
//  Created by Sarawoot Khunsri on 23/11/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit
import AmityUIKit

class CustomMessageTextIncomingTableViewCell: UITableViewCell, AmityMessageCellProtocol {

    @IBOutlet private var displayTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    func display(message: AmityMessageModel) {
        displayTextLabel.text = message.data?["text"] as? String
    }
}
