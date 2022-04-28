//
//  AmityNewsFeedDataModel.swift
//  AmityUIKit
//
//  Created by Jiratin Teean on 28/4/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation

struct AmityNewsFeedAmDataModel: Decodable {
    
    let post: AmityFeedPostModel
    let dataType: String
    let postId: String
    let parentPostId: String
    
    enum CodingKeys: String, CodingKey {
        case post = "post"
        case dataType = "dataType"
        case postId = "postId"
        case parentPostId = "parentPostId"
    }
}

struct AmityFeedPostModel: Decodable {
    
    let post: String
    let dataType: String
    let postId: String
    let parentPostId: String
    
    enum CodingKeys: String, CodingKey {
        case post = "post"
        case dataType = "dataType"
        case postId = "postId"
        case parentPostId = "parentPostId"
    }
}
