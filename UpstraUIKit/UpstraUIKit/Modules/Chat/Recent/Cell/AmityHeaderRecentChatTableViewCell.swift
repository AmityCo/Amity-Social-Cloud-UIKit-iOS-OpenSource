//
//  AmityHeaderRecentChatTableViewCell.swift
//  AmityUIKit
//
//  Created by Jiratin Teean on 27/7/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import UIKit

class AmityHeaderRecentChatTableViewCell: UITableViewCell, Nibbable {

    @IBOutlet private var announcementLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        announcementLabel.font = AmityFontSet.caption
        announcementLabel.text = AmityLocalizedStringSet.RecentMessage.announcementMessage.localizedString
    }
    
}
