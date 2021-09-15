//
//  ItemOptionTableViewCell.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 14/9/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

class ItemOptionTableViewCell: UITableViewCell, Nibbable {

    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageBackgroundView.layer.cornerRadius = 16
        imageBackgroundView.clipsToBounds = true
        imageBackgroundView.isHidden = true
    }
    
}
