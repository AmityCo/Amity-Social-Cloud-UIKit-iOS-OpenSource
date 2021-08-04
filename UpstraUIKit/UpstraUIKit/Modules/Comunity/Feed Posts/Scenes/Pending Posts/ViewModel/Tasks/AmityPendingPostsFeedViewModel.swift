//
//  AmityPendingPostsFeedViewModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 13/7/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityPendingPostsFeedViewModelProtocol {
    func getReviewingFeed(hasEditCommunityPermission: Bool, _ completion: (([AmityPostComponent]) -> Void)?)
}

final class AmityPendingPostsFeedViewModel: AmityPendingPostsFeedViewModelProtocol {
    
    private weak var feedRepositoryManager: AmityFeedRepositoryManagerProtocol?
    private var communityId: String
    
    init(communityId: String,
         feedRepositoryManager: AmityFeedRepositoryManagerProtocol)  {
        self.communityId = communityId
        self.feedRepositoryManager = feedRepositoryManager
    }
    
    // Pending Posts
    func getReviewingFeed(hasEditCommunityPermission: Bool, _ completion: (([AmityPostComponent]) -> Void)?) {
        feedRepositoryManager?.retrieveFeed(withFeedType: .pendingPostsFeed(communityId: communityId), completion: { [weak self] (result) in
            switch result {
            case .success(let posts):
                self?.preparePostComponent(posts: posts, hasEditCommunityPermission: hasEditCommunityPermission, completion)
            case .failure:
                completion?([])
            }
        })
    }
    
    // Prepare post component
    private func preparePostComponent(posts: [AmityPostModel], hasEditCommunityPermission: Bool, _ completion: (([AmityPostComponent]) -> Void)?) {
        var postComponents = [AmityPostComponent]()

        for post in posts {
            let component = AmityPendingPostsComponent(post: post, hasEditCommunityPermission: hasEditCommunityPermission)
            postComponents.append(AmityPostComponent(component: component))
        }
        
        completion?(postComponents)
    }
  
}
