//
//  NibFileOwnerLoadable.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 29/5/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

/// The protocol help to matching uiview class and xib file as the same name
protocol NibFileOwnerLoadable: UIView {
    var contentView: UIView! { get set }
}

extension NibFileOwnerLoadable {
    
    /// Returns a `UIView` object instantiated from
    /// - Returns: `UIView`
    func instantiateFromNib() -> UIView? {
        let nib = UINib(nibName: String(describing: Self.self), bundle: Bundle(for: Self.self))
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view
    }
    
    /// * Load the content of the first view in the XIB.
    /// * Then add this as subview with constraints
    func loadNibContent() {
        guard let view = instantiateFromNib() else {
            fatalError("Failed to instantiate \(String(describing: Self.self)).xib")
        }
        contentView = view
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leftAnchor.constraint(equalTo: leftAnchor),
            view.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
}
