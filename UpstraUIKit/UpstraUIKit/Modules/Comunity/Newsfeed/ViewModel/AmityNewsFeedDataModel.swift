//
//  AmityNewsFeedDataModel.swift
//  AmityUIKit
//
//  Created by Jiratin Teean on 28/4/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation

struct AmityNewsFeedDataModel: Decodable {
        
//    enum CodingKeys: String, CodingKey {
//        case posts = "posts"
//    }
    
    var posts: [AmityFeedPostModel]
}

struct AmityFeedPostModel: Decodable {
    
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case path = "path"
//        case sharedCount = "sharedCount"
//        case tragetType = "targetType"
//        case dataType = "dataType"
//        case commentsCount = "commentsCount"
//        case editedAt = "editedAt"
//        case createdAt = "createdAt"
//        case updateAt = "updatedAt"
//        case isDeleted = "isDeleted"
//        case hasFlaggedComment = "hasFlaggedComment"
//        case hasFlaggedChildren = "hasFlaggedChildren"
//        case postId = "postId"
//        case postedUserId = "postedUserId"
//        case targetId = "targetId"
//        case flagCount = "flagCount"
//        case hashFlag = "hashFlag"
//        case reactionsCount = "reactionsCount"
//        case feedId = "feedId"
//    }
    
    let id: String
    let path: String
    let sharedCount: Int
    let tragetType: String
    let dataType: String
    let commentsCount: String
    let editedAt: String
    let createdAt: String
    let updateAt: String
    let isDeleted: Bool
    let hasFlaggedComment: Bool
    let hasFlaggedChildren: Bool
    let postId: String
    let postedUserId: String
    let targetId: String
    let flagCount: Int
    let hashFlag: String
    let reactionsCount: Int
    let feedId: String
}
