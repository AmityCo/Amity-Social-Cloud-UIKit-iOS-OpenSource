//
//  ChatSettingsTableViewCell.swift
//  AmityUIKit
//
//  Created by min khant on 05/05/2021.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

class ChatSettingsTableViewCell: UITableViewCell, Nibbable {

    static let cellDefaultHeight: CGFloat = 52
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(title: String, textColor: UIColor) {
        titleLabel.text = title
        titleLabel.font =  .systemFont(ofSize: 13, weight: .regular)
        titleLabel.textColor = textColor
    }
    
}
