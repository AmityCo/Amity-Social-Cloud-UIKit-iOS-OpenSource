//
//  EkoDynamicHeightTableView.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 8/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

class EkoDynamicHeightTableView: UITableView {

    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != self.intrinsicContentSize {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}


