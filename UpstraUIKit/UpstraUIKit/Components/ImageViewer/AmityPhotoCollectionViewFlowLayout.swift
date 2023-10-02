//
//  AmityPhotoCollectionViewFlowLayout.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 26/7/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

class AmityPhotoCollectionViewFlowLayout: UICollectionViewFlowLayout {
    var currentIndex: Int?
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        invalidateLayout()
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        if let index = currentIndex, let collectionView = collectionView {
            currentIndex = nil
            return CGPoint(x: CGFloat(index) * collectionView.frame.size.width, y: 0)
        }
        
        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
    }
}

