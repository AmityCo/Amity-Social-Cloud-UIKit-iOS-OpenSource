//
//  AmityReactionUserSkeletonCell.swift
//  AmityUIKit
//
//  Created by Amity on 28/4/2566 BE.
//  Copyright © 2566 BE Amity. All rights reserved.
//

import UIKit

class AmityReactionUserSkeletonCell: UITableViewCell, Nibbable {

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var label1: UIView!
    @IBOutlet weak var label2: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.setupViews()
    }
    
    func setupViews() {
        contentView.backgroundColor = AmityColorSet.backgroundColor
        [circleView, label1, label2].forEach {
            $0?.backgroundColor = AmityColorSet.base.blend(.shade4)
            $0?.layer.masksToBounds = true
        }
        circleView.layer.cornerRadius = 20
        label1.layer.cornerRadius = 6
        label2.layer.cornerRadius = 6
    }
}
