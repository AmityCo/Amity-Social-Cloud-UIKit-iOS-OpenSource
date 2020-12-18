//
//  EkoHUDErrorView.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 22/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

class EkoHUDErrorView: UIView {
    
    private let imageView = UIImageView(frame: .zero)
    private let label = UILabel(frame: .zero)
    
    init(message: String) {
        super.init(frame: .zero)
        setup(with: message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(with message: String) {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        layer.cornerRadius = 4
        clipsToBounds = true
        addSubview(imageView)
        addSubview(label)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = EkoIconSet.iconClose
        imageView.tintColor = EkoColorSet.baseInverse
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = EkoColorSet.baseInverse
        label.font = EkoFontSet.headerLine
        label.text = message
        label.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18) ])
    }
}

