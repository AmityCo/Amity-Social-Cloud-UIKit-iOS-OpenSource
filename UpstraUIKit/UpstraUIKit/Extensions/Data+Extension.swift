//
//  Data+Extension.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 9/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import Foundation

extension Data {

    func write(withName name: String) -> URL {
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name)
        try! write(to: url, options: .atomicWrite)
        return url
    }
}
