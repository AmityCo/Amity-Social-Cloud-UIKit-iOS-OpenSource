//
//  EkoFeedScreenViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/13/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoFeedScreenViewModelDelegate: class {
    func screenViewModelDidUpdateDataSuccess(_ viewModel: EkoFeedScreenViewModelType)
    func screenViewModelLoadingState(_ viewModel: EkoFeedScreenViewModelType, for loadingState: EkoLoadingState)
    func screenViewModelScrollToTop(_ viewModel: EkoFeedScreenViewModelType)
    func screenViewModelDidSuccess(_ viewModel: EkoFeedScreenViewModelType, message: String)
    func screenViewModelDidFail(_ viewModel: EkoFeedScreenViewModelType, failure error: EkoError)
    
    // MARK: Post
    func screenViewModelDidLikePostSuccess(_ viewModel: EkoFeedScreenViewModelType)
    func screenViewModelDidUnLikePostSuccess(_ viewModel: EkoFeedScreenViewModelType)
    func screenViewModelDidGetReportStatusPost(isReported: Bool)
    
    // MARK: Commend
    func screenViewModelDidLikeCommentSuccess(_ viewModel: EkoFeedScreenViewModelType)
    func screenViewModelDidUnLikeCommentSuccess(_ viewModel: EkoFeedScreenViewModelType)
    func screenViewModelDidDeleteCommentSuccess(_ viewModel: EkoFeedScreenViewModelType)
    func screenViewModelDidEditCommentSuccess(_ viewModel: EkoFeedScreenViewModelType)
}

protocol EkoFeedScreenViewModelDataSource {
    // MARK: PostComponents
    func postComponents(in section: Int) -> EkoPostComponent
    func numberOfPostComponents() -> Int
    func getFeedType() -> EkoPostFeedType
}

protocol EkoFeedScreenViewModelAction {
    
    // MARK: Fetch data
    func fetchPosts()
    func loadMore()
    func reload()
    
    // MARK: PostId / CommentId
    func like(id: String, referenceType: EkoReactionReferenceType)
    func unlike(id: String, referenceType: EkoReactionReferenceType)
    
    // MARK: Post
    func delete(withPostId postId: String)
    func report(withPostId postId: String)
    func unreport(withPostId postId: String)
    func getReportStatus(withPostId postId: String)
    
    // MARK: Comment
    func delete(withComment comment: EkoCommentModel)
    func edit(withComment comment: EkoCommentModel, text: String)
    func report(withCommentId commentId: String)
    func unreport(withCommentId commentId: String)
    func getReportStatus(withCommendId commendId: String, completion: @escaping (Bool) -> Void)
    
    // MARK: Observer
    func startObserveFeedUpdate()
    func stopObserveFeedUpdate()
}

protocol EkoFeedScreenViewModelType: EkoFeedScreenViewModelAction, EkoFeedScreenViewModelDataSource {
    var delegate: EkoFeedScreenViewModelDelegate? { get set }
    var action: EkoFeedScreenViewModelAction { get }
    var dataSource: EkoFeedScreenViewModelDataSource { get }
}

extension EkoFeedScreenViewModelType {
    var action: EkoFeedScreenViewModelAction { return self }
    var dataSource: EkoFeedScreenViewModelDataSource { return self }
}
