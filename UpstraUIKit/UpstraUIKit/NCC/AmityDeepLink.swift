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
    case chat
    case none
}

public struct AmityCommunityEventTypeModel {
    public var openType:AmityCommunityEventOpenType = .none
    public var postID: String?
    public var communityID: String?
    public var categoryID: String?
    public var channelID: String?
    public init(openType: AmityCommunityEventOpenType, postID: String? = nil, communityID: String? = nil, categoryID: String? = nil, channelID: String? = nil) {
        self.openType = openType
        self.postID = postID
        self.communityID = communityID
        self.categoryID = categoryID
        self.channelID = channelID
    }
}
