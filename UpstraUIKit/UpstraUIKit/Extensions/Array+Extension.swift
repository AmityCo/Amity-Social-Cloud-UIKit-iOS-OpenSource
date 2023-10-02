//
//  Array+Extension.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 12/5/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation

extension Array where Iterator.Element: Hashable {
    
    public var hashValue: Int {
        return self.reduce(1, { $0.hashValue ^ $1.hashValue })
    }
    
}
