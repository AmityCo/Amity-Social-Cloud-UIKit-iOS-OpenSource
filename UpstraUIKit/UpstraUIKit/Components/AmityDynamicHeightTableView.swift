//
//  AmityDynamicHeightTableView.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 8/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

// Note:
// Use this tableview subclass when you want your tableview height
// to be equal to its content size height.
//
// By using this you lose cell reuse advantage for tableview.
// So use this with caution!!
class AmityDynamicHeightTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
