//
//  EkoPostViewAllCommentsTableViewCell.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 25/2/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import UIKit

public class EkoPostViewAllCommentsTableViewCell: UITableViewCell, Nibbable {

    @IBOutlet weak var titleLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = EkoColorSet.backgroundColor
        titleLabel.text = EkoLocalizedStringSet.viewAllCommentsTitle.localizedString
        titleLabel.font = EkoFontSet.bodyBold
        titleLabel.textColor = EkoColorSet.base
    }
    
}
