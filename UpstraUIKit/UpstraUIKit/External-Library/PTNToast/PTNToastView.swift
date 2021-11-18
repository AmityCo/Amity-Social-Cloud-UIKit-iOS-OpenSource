//
//  NotificationInAppView.swift
//  Potioneer
//
//  Created by PrInCeInFiNiTy on 3/7/2564 BE.
//  Copyright © 2564 BE PrInCeInFiNiTy. All rights reserved.
//

import UIKit

class PTNToastView: UIView {
    
    @IBOutlet weak var viewBackground: UIView! {
        didSet {
            viewBackground.layer.cornerRadius = viewBackground.frame.width / 10
        }
    }
    @IBOutlet weak var lblTitle: UILabel! {
        didSet {
            lblTitle.font = AmityFontSet.bodyBold
            lblTitle.textColor = UIColor.white
        }
    }
    
}
