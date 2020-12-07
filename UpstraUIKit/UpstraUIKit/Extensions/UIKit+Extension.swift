//
//  Foundation+Extension.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 23/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

protocol Nibbable: class {
    static var nib: UINib { get }
}

extension Nibbable {
    
    static var nib: UINib {
        guard let nibName = NSStringFromClass(Self.self).components(separatedBy: ".").last else {
            fatalError("Class name not found")
        }
        return UINib(nibName: nibName, bundle: UpstraUIKitManager.bundle)
    }
    
}
