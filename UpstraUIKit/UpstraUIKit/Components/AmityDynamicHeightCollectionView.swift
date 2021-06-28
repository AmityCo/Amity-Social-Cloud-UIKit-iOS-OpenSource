//
//  AmityDynamicHeightCollectionView.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 30/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

class AmityDynamicHeightCollectionView: UICollectionView {
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

