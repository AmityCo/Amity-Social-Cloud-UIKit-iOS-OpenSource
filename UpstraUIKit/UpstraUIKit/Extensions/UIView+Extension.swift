//
//  UIView+Extension.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 29/5/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

extension UIView {
    
    public static var identifier: String {
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

extension UIView {
    
    enum Edge {
        case leading(constant: CGFloat)
        case trailing(constant: CGFloat)
        case top(constant: CGFloat)
        case bottom(constant: CGFloat)
    }

    func align(edges: [Edge], to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        for (_, edge) in edges.enumerated() {
            switch edge {
            case .top(let constant):
                if #available(iOS 11.0, *) {
                    let constraint = topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constant)
                    constraints.append(constraint)
                } else {
                    let constraint = topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: constant)
                    constraints.append(constraint)
                }
            case .bottom(let constant):
                if #available(iOS 11.0, *) {
                    let constraint = bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -constant)
                    constraints.append(constraint)
                } else {
                    let constraint = bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -constant)
                    constraints.append(constraint)
                }
                
            case .leading(let constant):
                constraints.append(leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant))
                
            case .trailing(let constant):
                constraints.append(trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant))
            }
        }
        NSLayoutConstraint.activate(constraints)
    }
    
}

extension UIView {

    func superview<T>(of type: T.Type) -> T? {
        return superview as? T ?? superview.flatMap { $0.superview(of: type) }
    }

    func subview<T>(of type: T.Type) -> T? {
        return subviews.compactMap { $0 as? T ?? $0.subview(of: type) }.first
    }

}
