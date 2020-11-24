//
//  CustomMessageTextIncomingTableViewCell.swift
//  SampleApp
//
//  Created by Sarawoot Khunsri on 23/11/2563 BE.
//  Copyright © 2563 BE Eko. All rights reserved.
//

import UIKit
import UpstraUIKit

class CustomMessageTextIncomingTableViewCell: UITableViewCell, EkoMessageCellProtocol {

    @IBOutlet private var displayTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    func display(message: EkoMessageModel) {
        displayTextLabel.text = message.data?["text"] as? String
    }
}
