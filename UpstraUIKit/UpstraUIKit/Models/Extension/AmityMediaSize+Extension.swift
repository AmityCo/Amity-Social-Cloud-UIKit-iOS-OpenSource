//
//  AmityMediaSize+Extension.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 10/5/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import AmitySDK

extension AmityMediaSize {
    
    var description: String {
        switch self {
        case .full:
            return "full"
        case .large:
            return "large"
        case .medium:
            return "medium"
        case .small:
            return "small"
        default:
            return ""
        }
    }
    
}
