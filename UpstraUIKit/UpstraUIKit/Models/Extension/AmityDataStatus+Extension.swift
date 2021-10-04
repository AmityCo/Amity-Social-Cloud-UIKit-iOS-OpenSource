//
//  AmityDataStatus+Extension.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 14/7/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import AmitySDK

extension AmityDataStatus {
    
    var description: String {
        switch self {
        case .notExist:
            return "notExist"
        case .local:
            return "local"
        case .fresh:
            return "fresh"
        case .error:
            return "error"
        default:
            return ""
        }
    }
    
}
