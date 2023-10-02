//
//  AmityFloatingButton.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 16/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

final class AmityFloatingButton: UIButton {
    
    enum Position {
        case topLeft, topRight, bottomLeft, bottomRight
    }
    
    var actionHandler: ((AmityFloatingButton) -> Void)?
    var size: CGSize = CGSize(width: 64, height: 64)
    var image: UIImage? {
        didSet {
            setImage(image, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func draw(_ rect: CGRect) {
        layer.backgroundColor = AmityColorSet.primary.cgColor
        layer.cornerRadius = size.height / 2
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 10)
    }
    
    private func setupView() {
        addTarget(self, action: #selector(onButtonTap(_:)), for: .touchUpInside)
    }
    
    @objc private func onButtonTap(_ sender: UIButton) {
        actionHandler?(self)
    }
    
    func add(to view: UIView, position: Position) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        
        switch position {
        case .bottomLeft, .bottomRight:
            let safeArea = view.safeAreaLayoutGuide
            bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16).isActive = true
        case .topLeft, .topRight:
            let safeArea = view.safeAreaLayoutGuide
            topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16).isActive = true
        }
        
        switch position {
        case .bottomLeft:
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        case .bottomRight:
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        case .topLeft:
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        case .topRight:
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        }
        
        view.bringSubviewToFront(self)
    }
}

