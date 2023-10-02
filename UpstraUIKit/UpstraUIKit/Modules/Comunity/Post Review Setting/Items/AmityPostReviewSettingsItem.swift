//
//  AmityPostReviewSettingsItem.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 11/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

enum AmityPostReviewSettingsItem: String {
    case approveMemberPost
    
    var identifier: String {
        return String(describing: self)
    }
    
    var title: String {
        switch self {
        case .approveMemberPost:
            return AmityLocalizedStringSet.PostReviewSettings.itemTitleApproveMemberPosts.localizedString
        }
    }
    
    var description: String? {
        switch self {
        case .approveMemberPost:
            return AmityLocalizedStringSet.PostReviewSettings.itemDescApproveMemberPosts.localizedString
        }
    }
    
    var icon: UIImage? {
        return nil
    }
}
