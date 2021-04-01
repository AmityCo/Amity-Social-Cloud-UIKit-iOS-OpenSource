//
//  EkoPostReviewSettingsItem.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 11/3/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import UIKit

enum EkoPostReviewSettingsItem: String {
    case approveMemberPost
    
    var identifier: String {
        return String(describing: self)
    }
    
    var title: String {
        switch self {
        case .approveMemberPost:
            return EkoLocalizedStringSet.PostReviewSettings.itemTitleApproveMemberPosts.localizedString
        }
    }
    
    var description: String? {
        switch self {
        case .approveMemberPost:
            return EkoLocalizedStringSet.PostReviewSettings.itemDescApproveMemberPosts.localizedString
        }
    }
    
    var icon: UIImage? {
        return nil
    }
}
