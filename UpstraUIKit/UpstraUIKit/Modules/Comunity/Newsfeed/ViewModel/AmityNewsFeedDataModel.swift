//
//  AmityNewsFeedDataModel.swift
//  AmityUIKit
//
//  Created by Jiratin Teean on 28/4/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation

struct AmityNewsFeedDataModel: Decodable {
        
    enum CodingKeys: String, CodingKey {
        case posts = "posts"
    }
    
    var posts: [AmityFeedPostModel]
}

struct AmityTodayNewsFeedDataModel: Decodable {
        
    enum CodingKeys: String, CodingKey {
        case post = "post"
    }
    
    var post: [AmityFeedPostModel]
}

struct AmityFeedPostModel: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case path = "path"
        case sharedCount = "sharedCount"
        case targetType = "targetType"
        case dataType = "dataType"
        case commentsCount = "commentsCount"
        case editedAt = "editedAt"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case isDeleted = "isDeleted"
        case hasFlaggedComment = "hasFlaggedComment"
        case hasFlaggedChildren = "hasFlaggedChildren"
        case data = "data"
        case postId = "postId"
        case postedUserId = "postedUserId"
        case targetId = "targetId"
        case flagCount = "flagCount"
        case hashFlag = "hashFlag"
        case reactions = "reactions"
        case reactionsCount = "reactionsCount"
        case myReactions = "myReactions"
        case comments = "comments"
        case children = "children"
        case feedId = "feedId"
        case mentionees = "mentionees"
        case tags = "tags"
    }
    
    let id: String?
    let path: String?
    let sharedCount: Int?
    let targetType: String?
    let dataType: String?
    let commentsCount: Int?
    let editedAt: String?
    let createdAt: String?
    let updatedAt: String?
    let isDeleted: Bool?
    let hasFlaggedComment: Bool?
    let hasFlaggedChildren: Bool?
    let data: TextNewsFeedDataModel?
    let postId: String?
    let postedUserId: String?
    let targetId: String?
    let flagCount: Int?
    let hashFlag: Bool?
    let reactions: ReactionNewsFeedDataModel?
    let reactionsCount: Int?
    let myReactions: [ReactionNewsFeedDataModel]
    let comments: [String]
    let children: [String]
    let feedId: String?
    let mentionees: [mentioneesNewsFeedDataModel]
    let tags: [String]
}

struct TextNewsFeedDataModel: Codable {
        
    enum CodingKeys: String, CodingKey {
        case text = "text"
    }
    
    let text: String?
}

struct ReactionNewsFeedDataModel: Codable {
        
    enum CodingKeys: String, CodingKey {
        case like = "like"
    }
    
    let like: Int?
}

struct mentioneesNewsFeedDataModel: Codable {
        
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case userIds = "userIds"
    }
    
    let type: String?
    let userIds: [String]?
}
