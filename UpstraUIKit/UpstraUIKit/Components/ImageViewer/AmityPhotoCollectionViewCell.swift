//
//  AmityPhotoCollectionViewCell.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 26/7/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

public protocol AmityPhotoCollectionViewCellDelegate: NSObjectProtocol {
    func collectionViewCellWillZoomOnPhoto(_ cell: AmityPhotoCollectionViewCell)
}

open class AmityPhotoCollectionViewCell: UICollectionViewCell {
    
    public private(set) var scrollView: AmityPhotoScrollView!
    
    public private(set) var imageView: UIImageView!
    
    public var zoomEnabled = true
    public private(set) var playImageView: UIImageView!
    
    lazy var extraLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = UIColor.white
        label.font = AmityFontSet.body
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
    
    weak var delegate: AmityPhotoCollectionViewCellDelegate?
    
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
        imageView.image = nil
        scrollView.zoomScale = 1.0
    }
    
    private func commonInit() {
        
        backgroundColor = .clear
        
        isUserInteractionEnabled = true
        
        // Scroll View
        scrollView = AmityPhotoScrollView(frame: .zero)
        scrollView.minimumZoomScale = minimumZoomScale
        scrollView.maximumZoomScale = 1.0 // Not allow zooming when there is no image
        scrollView.delegate = self
        
        // Image View
        let imageView = AmityPhotoImageView(frame: CGRect.zero)
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
        
        // Play Image View
        playImageView = UIImageView()
        playImageView.contentMode = .scaleAspectFit
        if #available(iOS 13.0, *) {
            playImageView.image = UIImage(systemName: "play.fill")
        } else {
            // Fallback on earlier versions
        }
        playImageView.tintColor = .white
        
        // Views Hierarchy
        scrollView.addSubview(imageView)
        contentView.addSubview(scrollView)
        contentView.addSubview(playImageView)
        
        playImageView.isHidden = true
        
        scrollView.contentInsetAdjustmentBehavior = .never
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
        
        // Align playImageView to center.
        playImageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        playImageView.center = CGPoint(
            x: contentView.bounds.width * 0.5,
            y: contentView.bounds.height * 0.5
        )
        
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
extension AmityPhotoCollectionViewCell: UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if zoomEnabled {
            return imageView
        }
        return nil
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
