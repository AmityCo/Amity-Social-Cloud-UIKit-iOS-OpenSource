//
//  EkoFeedScreenViewModelType.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 6/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

public enum FeedType {
    case globalFeed
    case myFeed
    case userFeed(userId: String)
    case communityFeed(communityId: String)
}

enum EkoFeedTapAction {
    case like
    case option
    case viewAllComment
    case avatar
    case image(EkoImage)
}

protocol EkoFeedScreenViewModelDataSource {
    var feedType: FeedType { get }
    func numberOfItems() -> Int
    func item(at indexPath: IndexPath) -> FeedViewModel
    func reloadData()
    func loadNext()
}

protocol EkoFeedScreenViewModelDelegate: class {
    func screenViewModelDidUpdateData(_ viewModel: EkoFeedScreenViewModelType)
}

protocol EkoFeedScreenViewModelAction {
    func likePost(postId: String)
    func unlikePost(postId: String)
    func deletePost(postId: String)
    func likeComment(commentId: String)
    func unlikeComment(commentId: String)
    func editComment(comment: EkoCommentModel, text: String)
    func deleteComment(comment: EkoCommentModel)
}

protocol EkoFeedScreenViewModelType: EkoFeedScreenViewModelAction, EkoFeedScreenViewModelDataSource {
    var action: EkoFeedScreenViewModelAction { get }
    var dataSource: EkoFeedScreenViewModelDataSource { get }
    var delegate: EkoFeedScreenViewModelDelegate? { get set }
}

extension EkoFeedScreenViewModelType {
    var action: EkoFeedScreenViewModelAction { return self }
    var dataSource: EkoFeedScreenViewModelDataSource { return self }
}

