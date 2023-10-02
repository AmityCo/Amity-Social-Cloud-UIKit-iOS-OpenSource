//
//  BottomSheetHandleView.swift
//  AmityUIKit
//
//  Created by Nishan Niraula on 1/23/20.
//  Copyright © 2020 Amity. All rights reserved.
//

import UIKit

final class BottomSheetHandleView: UIView, BottomSheetComponent {
    
    public var handleWidth: CGFloat = 42 {
        didSet {
            widthConstraint.constant = handleWidth
        }
    }
    public var handleHeight: CGFloat = 6 {
        didSet {
            heightConstraint.constant = handleHeight
        }
    }
    
    public var handleMargin: CGFloat = 12 {
        didSet {
            topConstraint.constant = handleMargin
        }
    }
    
    public var componentHeight: CGFloat {
        return handleHeight + handleMargin
    }
    
    private let imageView = UIImageView()
    private var widthConstraint: NSLayoutConstraint!
    private var heightConstraint: NSLayoutConstraint!
    private var topConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = AmityColorSet.backgroundColor
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        
        widthConstraint = imageView.widthAnchor.constraint(equalToConstant: handleWidth)
        heightConstraint = imageView.heightAnchor.constraint(equalToConstant: handleHeight)
        topConstraint = imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: handleMargin)
        let centerConstraint = imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        
        NSLayoutConstraint.activate([widthConstraint, heightConstraint, topConstraint, centerConstraint])
    }
}
