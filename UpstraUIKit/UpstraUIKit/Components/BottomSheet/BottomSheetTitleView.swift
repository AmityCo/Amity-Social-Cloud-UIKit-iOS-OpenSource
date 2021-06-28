//
//  BottomSheetTitleView.swift
//  AmityUIKit
//
//  Created by Nishan Niraula on 1/23/20.
//  Copyright © 2020 Amity. All rights reserved.
//

import UIKit

public class BottomSheetTitleView: UIView, BottomSheetComponent {
    
    public var titleLabel = UILabel()
    public var componentHeight: CGFloat { return 50 }
    public var rightButtonAction: (()->())?
    public var rightButton = UIButton()
    
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
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        
        titleLabel.textAlignment = .center
        titleLabel.text = "Sheet Title"
        titleLabel.font = AmityFontSet.title
    }
    
    public func setupRightButton() {
        rightButton = UIButton()
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rightButton)
        bringSubviewToFront(rightButton)
        
        NSLayoutConstraint.activate([
            rightButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            rightButton.topAnchor.constraint(equalTo: self.topAnchor),
            rightButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        rightButton.addTarget(self, action: #selector(onRightButtonTap), for: .touchUpInside)
    }
    
    @objc func onRightButtonTap() {
        rightButtonAction?()
    }
}
