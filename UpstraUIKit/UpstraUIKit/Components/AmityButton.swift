//
//  AmityButton.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 8/6/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

/// Amity button for custom display and states
public class AmityButton: UIButton {
    public enum Position {
        case left, right
    }
    
    /// callback action
    public var touchUpHandler: (() -> Void)?
    
    var attributedString = AmityAttributedString()
    private var tintColors: [UIControl.State.RawValue: UIColor] = [:]
    
    public override var isSelected: Bool {
        didSet {
            tintColor = tintColors[state.rawValue]
        }
    }
    
    func setTintColor(_ color: UIColor?, for state: UIControl.State) {
        tintColors[state.rawValue] = color
        tintColor = tintColors[state.rawValue]
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    }
    
    @objc private func touchUpInside(_ sender: UIButton) {
        touchUpHandler?()
    }
    
    /// Set image for button position left/right
    /// - Parameter image: UIImage from local storage
    public func setImage(_ image: UIImage?, position: Position = .right, constant: CGFloat = 16) {
        setImage(image, for: .normal)
        switch position {
        case .left:
            semanticContentAttribute = .forceLeftToRight
            imageEdgeInsets = .init(top: 0, left: -constant, bottom: 0, right: 0)
        case .right:
            semanticContentAttribute = .forceRightToLeft
            imageEdgeInsets = .init(top: 0, left: constant, bottom: 0, right: 0)
        }
    }
    
    /// Set font for button
    public func setTitleFont(_ font: UIFont) {
        titleLabel?.font = font
    }
    
    func setAttributedTitle() {
        UIView.setAnimationsEnabled(false)
        setAttributedTitle(attributedString.build(), for: .normal)
        layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
    }
    
}

