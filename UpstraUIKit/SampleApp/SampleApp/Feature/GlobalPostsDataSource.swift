//
//  GlobalPostsDataSource.swift
//  SampleApp
//
//  Created by Hamlet on 01.03.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import Foundation
import AmitySDK

class GlobalPostsDataSource {
    
    let client: AmityClient
    let feedRepository: AmityFeedRepository
    
    var postCollection: AmityCollection<AmityPost>?
    var feedCollectionToken: AmityNotificationToken?
    
    init(client: AmityClient) {
        self.client = client
        self.feedRepository = AmityFeedRepository(client: client)
    }
    
    // MARK:- Feed Observer
    func observePostsFeedChanges(changeHandler:@escaping ()->()) {
        postCollection = feedRepository.getGlobalFeed()
        feedCollectionToken = postCollection?.observe({(collection, _, error) in
            changeHandler()
        })
    }
    
    func getPostAtIndex(index: Int) -> PostPreviewModel? {
        guard let post = postCollection?.object(at: index) else { return nil }
        return PostPreviewModel(post: post)
    }
    
    func getNumberOfFeedItems() -> Int {
        let count = Int(postCollection?.count() ?? 0)
        return count
    }
    
    func loadMorePosts() {
        guard let hasMorePosts = postCollection?.hasNext, hasMorePosts else { return }
        
        postCollection?.nextPage()
    }
}

struct PostPreviewModel {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return formatter
    }()
    
    let postId: String
    let dataType: String
    let userId: String
    let allCommentCount: Int
    let isDeleted: Bool
    let createdAt: String
    let reactionsCount: Int
    
    private let title: String
    private let myReactions: [String]?
    
    var myReactionsString: String {
        guard let reactions = myReactions else { return "" }
        return reactions.joined(separator: ", ")
    }
    
    var description: String {
        return "{\"date\":\"\(createdAt)\",\"title\":\"\(title)\",\"postId\":\"\(postId)\"}"
    }
    
    init(post: AmityPost) {
        postId = post.postId
        userId = post.postedUserId
        title = "\(post.data?["title"] ?? "")"
        reactionsCount = Int(post.reactionsCount)
        myReactions = post.myReactions as? [String]
        allCommentCount = Int(post.commentsCount)
        isDeleted = post.isDeleted
        createdAt = PostPreviewModel.dateFormatter.string(from: post.createdAt)
        
        var postDataType = post.dataType
        if post.childrenPosts.count > 0 {
            for eachChild in post.childrenPosts {
                switch eachChild.dataType {
                case "image":
                    postDataType = "image"
                case "file":
                    if let _ = eachChild.getFileInfo() {
                        postDataType = "file"
                    }
                default:
                    postDataType = post.dataType
                }
            }
        }
        
        dataType = postDataType
    }
}
