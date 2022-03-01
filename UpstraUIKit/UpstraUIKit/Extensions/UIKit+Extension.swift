//
//  Foundation+Extension.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 23/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

public protocol AmityCellIdentifiable: AnyObject {
    static var cellIdentifier: String { get }
}

extension AmityCellIdentifiable {
    public static var cellIdentifier: String {
        return String(describing: self)
    }
}

public protocol Nibbable: AnyObject {
    static var nib: UINib { get }
}

extension Nibbable {
    
    static public var nib: UINib {
        guard let nibName = NSStringFromClass(Self.self).components(separatedBy: ".").last else {
            fatalError("Class name not found")
        }
        return UINib(nibName: nibName, bundle: AmityUIKitManager.bundle)
    }
    
}
