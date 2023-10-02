//
//  AmityPostViewAllCommentsTableViewCell.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 25/2/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

public class AmityPostViewAllCommentsTableViewCell: UITableViewCell, Nibbable, AmityCellIdentifiable {

    @IBOutlet weak var titleLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = AmityColorSet.backgroundColor
        titleLabel.text = AmityLocalizedStringSet.viewAllCommentsTitle.localizedString
        titleLabel.font = AmityFontSet.bodyBold
        titleLabel.textColor = AmityColorSet.base
    }
    
}
