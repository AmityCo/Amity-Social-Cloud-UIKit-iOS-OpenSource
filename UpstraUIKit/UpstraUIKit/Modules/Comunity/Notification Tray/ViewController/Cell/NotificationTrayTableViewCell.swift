//
//  NotificationTrayTableViewCell.swift
//  AmityUIKit
//
//  Created by GuIDe'MacbookAmityHQ on 3/11/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import UIKit

class NotificationTrayTableViewCell: UITableViewCell, Nibbable {
    
    @IBOutlet private weak var avatarView: AmityAvatarView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var readMark: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = AmityColorSet.backgroundColor
        contentView.backgroundColor = AmityColorSet.backgroundColor
        titleLabel.font = AmityFontSet.bodyBold
        titleLabel.textColor = AmityColorSet.base
        descLabel.font = AmityFontSet.bodyBold
        descLabel.textColor = AmityColorSet.base
        dateLabel.font = AmityFontSet.caption
        dateLabel.textColor = .gray
        readMark.layer.cornerRadius = readMark.frame.size.width/2
        readMark.clipsToBounds = true
        readMark.isHidden = true
        contentView.backgroundColor = .white
    }
    
    func configure(model: NotificationModel) {
        if !(model.customImageUrl?.isEmpty ?? false) {
            avatarView.setImage(withCustomURL: model.customImageUrl, placeholder: AmityIconSet.defaultAvatar)
        } else {
            avatarView.setImage(withImageURL: model.imageUrl, placeholder: AmityIconSet.defaultAvatar)
        }
        avatarView.placeholderPostion = .fullSize
        titleLabel.text = model.targetType == "community" ? "Community" : "Post"
        descLabel.text = model.description
        
        let date = Date(timeIntervalSince1970: Double(model.lastUpdate ?? 0) / 1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+7") //Set timezone that you want
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        dateLabel.text = strDate
        
        if model.hasRead ?? true {
            readMark.isHidden = false
            contentView.backgroundColor = UIColor(hex: "E1E1E1")
        }
    }
}
