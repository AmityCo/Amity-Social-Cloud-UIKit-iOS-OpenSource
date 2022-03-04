//
//  UIView+Extension.swift
//  AmityUIKitLiveStream
//
//  Created by PrInCeInFiNiTy on 4/3/2565 BE.
//

import UIKit
import Foundation

internal extension UIView {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    /// Help to add constraint to parent such as top, bottom, leading, trailing
    func fit(to parent: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor),
            bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor),
            leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            trailingAnchor.constraint(equalTo: parent.trailingAnchor)
        ])
    }
    
}
