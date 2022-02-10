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
    case unableToLeaveCommunity = 400317
    case unAuthorizedError = 400100
    case itemNotFound = 400400
    case badRequestError = 400000
    case conflict = 400900
    case forbiddenError = 400300
    case userIsMuted = 400302
    case channelIsMuted = 400303
    case userIsBanned = 400304
    case numberOfMemberExceed = 400305
    case exemptFromBan = 400306
    case maxRepetitionExceed = 400307
    case linkNotAllowed = 400309
    case userIsGlobalBanned = 400312
    case businessError = 500000
    
    init?(error: Error?) {
        guard let errorCode = error?._code,
              let _error = AmityError(rawValue: errorCode) else {
            return nil
        }
        self = _error
    }
}
