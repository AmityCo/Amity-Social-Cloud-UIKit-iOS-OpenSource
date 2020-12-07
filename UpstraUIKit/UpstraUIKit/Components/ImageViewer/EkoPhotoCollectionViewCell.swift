//
//  EkoPhotoCollectionViewCell.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 26/7/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

public protocol EkoPhotoCollectionViewCellDelegate: NSObjectProtocol {
    func collectionViewCellWillZoomOnPhoto(_ cell: EkoPhotoCollectionViewCell)
}

open class EkoPhotoCollectionViewCell: UICollectionViewCell {
    
    public private(set) var scrollView: EkoPhotoScrollView!
    public private(set) var imageView: UIImageView!
    lazy var extraLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = UIColor.white
        label.font = EkoFontSet.body
        return label
    }()
    
    // default is 1.0
    open var minimumZoomScale: CGFloat = 1.0 {
        willSet {
            if imageView.image == nil {
                scrollView.minimumZoomScale = 1.0
            } else {
                scrollView.minimumZoomScale = newValue
            }
        }
        didSet {
            correctCurrentZoomScaleIfNeeded()
        }
    }
    
    // default is 3.0.
    open var maximumZoomScale: CGFloat = 3.0 {
        willSet {
            if imageView.image == nil {
                scrollView.maximumZoomScale = 1.0
            } else {
                scrollView.maximumZoomScale = newValue
            }
        }
        didSet {
            correctCurrentZoomScaleIfNeeded()
        }
    }
    
    weak var delegate: EkoPhotoCollectionViewCellDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        scrollView.zoomScale = 1.0
    }
    
    private func commonInit() {
        backgroundColor = UIColor.clear
        isUserInteractionEnabled = true
        scrollView = EkoPhotoScrollView(frame: .zero)
        scrollView.minimumZoomScale = minimumZoomScale
        scrollView.maximumZoomScale = 1.0 // Not allow zooming when there is no image
        
        let imageView = EkoPhotoImageView(frame: CGRect.zero)
        // Layout subviews every time getting new image
        imageView.imageChangeBlock = { [weak self] image in
            // Update image frame whenever image changes
            if let strongSelf = self {
                if image == nil {
                    strongSelf.scrollView.minimumZoomScale = 1.0
                    strongSelf.scrollView.maximumZoomScale = 1.0
                } else {
                    strongSelf.scrollView.minimumZoomScale = strongSelf.minimumZoomScale
                    strongSelf.scrollView.maximumZoomScale = strongSelf.maximumZoomScale
                    strongSelf.setNeedsLayout()
                }
                strongSelf.correctCurrentZoomScaleIfNeeded()
            }
        }
        
        imageView.contentMode = .scaleAspectFit
        self.imageView = imageView
        scrollView.delegate = self
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    private func correctCurrentZoomScaleIfNeeded() {
        if scrollView.zoomScale < scrollView.minimumZoomScale {
            scrollView.zoomScale = scrollView.minimumZoomScale
        }
        
        if scrollView.zoomScale > scrollView.maximumZoomScale {
            scrollView.zoomScale = scrollView.maximumZoomScale
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        
        //Set the aspect ration of the image
        if let image = imageView.image {
            let size = image.size
            let horizontalScale = size.width / scrollView.frame.width
            let verticalScale = size.height / scrollView.frame.height
            let factor = max(horizontalScale, verticalScale)
            
            //Divide the size by the greater of the vertical or horizontal shrinkage factor
            let width = size.width / factor
            let height = size.height / factor
            
            if scrollView.zoomScale != 1 {
                // If current zoom scale is not at default value, we need to maintain
                // imageView's size while laying out subviews
                
                // Calculate new zoom scale corresponding to current default size to maintain
                // imageView's size
                let newZoomScale = scrollView.zoomScale * imageView.bounds.width / width
                
                // Update scrollView's maximumZoomScale or minimumZoomScale if needed
                // in order to ensure that updating its zoomScale works.
                if newZoomScale > scrollView.maximumZoomScale {
                    scrollView.maximumZoomScale = newZoomScale
                } else if newZoomScale < scrollView.minimumZoomScale {
                    scrollView.minimumZoomScale = newZoomScale
                }
                
                // Reset scrollView's maximumZoomScale or minimumZoomScale if needed
                if newZoomScale <= maximumZoomScale, scrollView.maximumZoomScale > maximumZoomScale {
                    scrollView.maximumZoomScale = maximumZoomScale
                }
                
                if newZoomScale >= minimumZoomScale, scrollView.minimumZoomScale < minimumZoomScale {
                    scrollView.minimumZoomScale = minimumZoomScale
                }
                
                // After updating scrollView's zoomScale, imageView's size will be updated
                // We need to revert it back to its original size.
                let imageViewSize = imageView.frame.size
                scrollView.setZoomScale(newZoomScale, animated: false)
                imageView.frame.size = imageViewSize // CGSize(width: width * newZoomScale, height: height * newZoomScale)
                scrollView.contentSize = imageViewSize
            } else {
                // If current zoom scale is at default value, just update imageView's size
                let x = (scrollView.frame.width - width) / 2
                let y = (scrollView.frame.height - height) / 2
                
                imageView.frame = CGRect(x: x, y: y, width: width, height: height)
            }
        }
        
        let insets: UIEdgeInsets

        if #available(iOS 11.0, *) {
            insets = safeAreaInsets
        } else {
            insets = UIEdgeInsets.zero
        }

        let width: CGFloat = 200
        extraLabel.frame = CGRect(x: bounds.size.width - width - 20 - insets.right, y: insets.top, width: width, height: 30)
    }
}

//MARK: - UIScrollViewDelegate
extension EkoPhotoCollectionViewCell: UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        delegate?.collectionViewCellWillZoomOnPhoto(self)
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateImageViewFrameForSize(frame.size)
    }
    
    private func updateImageViewFrameForSize(_ size: CGSize) {
        let y = max(0, (size.height - imageView.frame.height) / 2)
        let x = max(0, (size.width - imageView.frame.width) / 2)
        imageView.frame.origin = CGPoint(x: x, y: y)
    }
    
}
