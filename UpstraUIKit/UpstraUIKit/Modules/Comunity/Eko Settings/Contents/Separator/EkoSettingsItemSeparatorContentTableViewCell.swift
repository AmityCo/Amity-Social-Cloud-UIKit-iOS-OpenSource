//
//  EkoSettingsItemSeparatorContentTableViewCell.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 7/3/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import UIKit

final class EkoSettingsItemSeparatorContentTableViewCell: UITableViewCell, Nibbable {

    // MARK: - IBOutlet Properties
    @IBOutlet private var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = EkoColorSet.backgroundColor
        contentView.backgroundColor = EkoColorSet.backgroundColor
        separatorView.backgroundColor = EkoColorSet.base.blend(.shade4)
    }

 
}
