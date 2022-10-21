//
//  AmityHUDLoadingView.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 8/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
#warning("#HUD")
#warning("Need to refactor hud view to support fullscreen and handle the content inside of itself")
class AmityHUDLoadingView: UIView {
    
    private let loadingIndicator = UIActivityIndicatorView(frame: .zero)
    private let label = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        layer.cornerRadius = 4
        clipsToBounds = true
        addSubview(loadingIndicator)
        addSubview(label)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.style = .large
        loadingIndicator.startAnimating()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .center
        label.textColor = AmityColorSet.baseInverse
        label.font = AmityFontSet.headerLine
        label.text = "Loading"
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            label.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 18),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12) ])
    }
}
