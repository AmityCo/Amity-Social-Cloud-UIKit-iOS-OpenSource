//
//  MosaicCollectionViewLayout.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 22/7/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

enum MosaicSegmentStyle {
    case one
    case two
    case three
    case four
    case grid
}

class MosaicLayout: UICollectionViewFlowLayout {

    var contentBounds = CGRect.zero
    var isEditingeMode: Bool = false
    var cachedAttributes = [UICollectionViewLayoutAttributes]()
    
    static func preferredSement(_ numberOfItem: Int, isEditingeMode: Bool) -> MosaicSegmentStyle {
        switch numberOfItem {
        case 1:
            return .one
        case 2:
            return .two
        case 3:
            return .three
        case 4:
            return .four
        default:
            return isEditingeMode ? .grid : .four
        }
    }
    
    /// - Tag: PrepareMosaicLayout
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }

        // Reset cached information.
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
        
        // For every item in the collection view:
        //  - Prepare the attributes.
        //  - Store attributes in the cachedAttributes array.
        //  - Combine contentBounds with attributes.frame.
        let count = collectionView.numberOfItems(inSection: 0)
        
        var currentIndex = 0
        var segment = MosaicLayout.preferredSement(count, isEditingeMode: isEditingeMode)
        var lastFrame: CGRect = .zero
        
        let cvWidth = collectionView.bounds.inset(by: collectionView.contentInset).width
        
        while currentIndex < count {
            let segmentFrame = CGRect(x: 0, y: lastFrame.maxY, width: cvWidth, height: cvWidth)
            
            var segmentRects = [CGRect]()
            switch segment {
            case .one:
                segmentRects = [segmentFrame]
                
            case .two:
                let horizontalSlices = segmentFrame.dividedIntegral(fraction: 0.5, from: .minXEdge, spacing: minimumInteritemSpacing)
                segmentRects = [horizontalSlices.first, horizontalSlices.second]
                
            case .three:
                let verticalSlices = segmentFrame.dividedIntegral(fraction: 0.5, from: .minYEdge, spacing: minimumLineSpacing)
                let bottomSlices = verticalSlices.second.dividedIntegral(fraction: 0.5, from: .minXEdge, spacing: minimumInteritemSpacing)
                segmentRects = [verticalSlices.first, bottomSlices.first, bottomSlices.second]
                
            case .four:
                let verticalSlices = segmentFrame.dividedIntegral(fraction: (2.0/3.0), from: .minYEdge)
                segmentRects = [verticalSlices.first]
                
            case .grid:
                let numberOfItems: CGFloat = 3
                let itemSpacing = (numberOfItems - 1) * minimumInteritemSpacing
                let itemWidth = (segmentFrame.width - itemSpacing) / numberOfItems
                let sizeOfItem = CGSize(width: itemWidth, height: itemWidth)
                let firstRects = CGRect(origin: CGPoint(x: 0, y: segmentFrame.minY + minimumLineSpacing), size: sizeOfItem)
                let secondRects = CGRect(origin: CGPoint(x: firstRects.maxX + minimumInteritemSpacing, y: segmentFrame.minY + minimumLineSpacing), size: sizeOfItem)
                let thirdRects = CGRect(origin: CGPoint(x: secondRects.maxX + minimumInteritemSpacing, y: segmentFrame.minY + minimumLineSpacing), size: sizeOfItem)
                segmentRects = [firstRects, secondRects, thirdRects]
            }
            
            // Create and cache layout attributes for calculated frames.
            for rect in segmentRects {
                let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: currentIndex, section: 0))
                attributes.frame = rect
                
                cachedAttributes.append(attributes)
                contentBounds = contentBounds.union(lastFrame)
                
                currentIndex += 1
                lastFrame = rect
            }
            segment = .grid
        }
    }

    /// - Tag: CollectionViewContentSize
    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }
    
    /// - Tag: ShouldInvalidateLayout
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }
    
    /// - Tag: LayoutAttributesForItem
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }
    
    /// - Tag: LayoutAttributesForElements
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArray = [UICollectionViewLayoutAttributes]()
        
        // Find any cell that sits within the query rect.
        guard let lastIndex = cachedAttributes.indices.last,
              let firstMatchIndex = binSearch(rect, start: 0, end: lastIndex) else { return attributesArray }
        
        // Starting from the match, loop up and down through the array until all the attributes
        // have been added within the query rect.
        for attributes in cachedAttributes[..<firstMatchIndex].reversed() {
            guard attributes.frame.maxY >= rect.minY else { break }
            attributesArray.append(attributes)
        }
        
        for attributes in cachedAttributes[firstMatchIndex...] {
            guard attributes.frame.minY <= rect.maxY else { break }
            attributesArray.append(attributes)
        }
        
        return attributesArray
    }
    
    // Perform a binary search on the cached attributes array.
    func binSearch(_ rect: CGRect, start: Int, end: Int) -> Int? {
        if end < start { return nil }
        
        let mid = (start + end) / 2
        let attr = cachedAttributes[mid]
        
        if attr.frame.intersects(rect) {
            return mid
        } else {
            if attr.frame.maxY < rect.minY {
                return binSearch(rect, start: (mid + 1), end: end)
            } else {
                return binSearch(rect, start: start, end: (mid - 1))
            }
        }
    }

}

extension CGRect {
    func dividedIntegral(fraction: CGFloat, from fromEdge: CGRectEdge, spacing: CGFloat = 0.0) -> (first: CGRect, second: CGRect) {
        let dimension: CGFloat
        
        switch fromEdge {
        case .minXEdge, .maxXEdge:
            dimension = self.size.width
        case .minYEdge, .maxYEdge:
            dimension = self.size.height
        }
        
        let distance = (dimension * fraction).rounded(.up)
        var slices = self.divided(atDistance: distance, from: fromEdge)
        let _spacing = spacing / 2.0
        
        switch fromEdge {
        case .minXEdge, .maxXEdge:
            slices.remainder.origin.x += _spacing
            slices.remainder.size.width -= _spacing
            slices.slice.size.width -= _spacing
        case .minYEdge, .maxYEdge:
            slices.slice.size.height -= _spacing
            slices.remainder.origin.y += _spacing
            slices.remainder.size.height -= _spacing
        }
        
        return (first: slices.slice, second: slices.remainder)
    }
}
