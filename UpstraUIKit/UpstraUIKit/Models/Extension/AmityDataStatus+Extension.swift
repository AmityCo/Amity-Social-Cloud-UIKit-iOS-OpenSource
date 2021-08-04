//
//  AmityDataStatus+Extension.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 14/7/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import AmitySDK

extension AmityDataStatus {
    
    var title: String {
        switch self {
        case .error: return "Error"
        case .fresh: return "Fresh"
        case .local: return "Local"
        case .notExist: return "notExist"
        @unknown default:
            return ""
        }
    }
    
}
