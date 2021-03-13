//
//  EkoCommunityCategoryModel.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 29/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

/// Eko Community Category 
public struct EkoCommunityCategoryModel {
    public let name: String
    let avatarFileId: String
    public let categoryId: String
    
    init(object: EkoCommunityCategory) {
        self.name = object.name
        self.avatarFileId = object.avatarFileId
        self.categoryId = object.categoryId
    }
}
