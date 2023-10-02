//
//  UICollectionView+Extension.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 28/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    /// help to map cell for register with Nib&Identifier
    func register<T: UICollectionViewCell&Nibbable>(_ cellClass: T.Type) {
        register(cellClass.nib, forCellWithReuseIdentifier: cellClass.identifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
    
}
