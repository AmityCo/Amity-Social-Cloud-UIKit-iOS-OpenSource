//
//  Error+Extension.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 28/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import Foundation

enum AmityError: Int, Error {
    
    case unknown = 99999
    case noPermission = 40301
    case bannedWord = 400308
    case noUserAccessPermission = 400301
    case fileServiceIsNotReady = 38528523
    case userNotFound = 40000001
    case unableToLeaveCommunity = 400317
    
    init?(error: Error?) {
        guard let errorCode = error?._code,
              let _error = AmityError(rawValue: errorCode) else {
            return nil
        }
        self = _error
    }
}
