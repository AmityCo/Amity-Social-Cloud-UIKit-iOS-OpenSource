//
//  AmityCommunityCategoryModel.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 29/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

/// Amity Community Category
public struct AmityCommunityCategoryModel {
    public let name: String
    let avatarURL: String
    public let categoryId: String
    
    init(object: AmityCommunityCategory) {
        self.name = object.name
        self.avatarURL = object.avatar?.fileURL ?? ""
        self.categoryId = object.categoryId
    }
}
