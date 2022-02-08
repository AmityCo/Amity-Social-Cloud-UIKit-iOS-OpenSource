//
//  AmityDeepLink.swift
//  AmityUIKit
//
//  Created by PrInCeInFiNiTy on 4/2/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation

public enum AmityCommunityEventOpenType {
    case post
    case community
    case category
    case none
}

public struct AmityCommunityEventTypeModel {
    var openType:AmityCommunityEventOpenType = .none
    var postID: String?
    var communityID: String?
    var categoryID: String?
    
    public init(openType: AmityCommunityEventOpenType, postID: String? = nil, communityID: String? = nil, categoryID: String? = nil) {
        self.openType = openType
        self.postID = postID
        self.communityID = communityID
        self.categoryID = categoryID
    }
}
