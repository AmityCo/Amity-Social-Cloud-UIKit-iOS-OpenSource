//
//  TodayNewsFeedViewModelProtocal.swift
//  AmityUIKit
//
//  Created by Jiratin Teean on 8/7/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol TodayNewsFeedScreenViewModelDelegate: AnyObject {
    func screenViewModelDidUpdateDataSuccess(_ viewModel: TodayNewsFeedScreenViewModelType)
    func screenViewModelLoadingState(_ viewModel: TodayNewsFeedScreenViewModelType, for loadingState: AmityLoadingState)
    func screenViewModelScrollToTop(_ viewModel: TodayNewsFeedScreenViewModelType)
    func screenViewModelDidSuccess(_ viewModel: TodayNewsFeedScreenViewModelType, message: String)
    func screenViewModelDidFail(_ viewModel: TodayNewsFeedScreenViewModelType, failure error: AmityError)
    func screenViewModelLoadingStatusDidChange(_ viewModel: TodayNewsFeedScreenViewModelType, isLoading: Bool)
    func screenViewModelDidDelete()
    
    // MARK: Post
    func screenViewModelDidLikePostSuccess(_ viewModel: TodayNewsFeedScreenViewModelType)
    func screenViewModelDidUnLikePostSuccess(_ viewModel: TodayNewsFeedScreenViewModelType)
    func screenViewModelDidGetReportStatusPost(isReported: Bool)
    
    // MARK: Comment
    func screenViewModelDidLikeCommentSuccess(_ viewModel: TodayNewsFeedScreenViewModelType)
    func screenViewModelDidUnLikeCommentSuccess(_ viewModel: TodayNewsFeedScreenViewModelType)
    func screenViewModelDidDeleteCommentSuccess(_ viewModel: TodayNewsFeedScreenViewModelType)
    func screenViewModelDidEditCommentSuccess(_ viewModel: TodayNewsFeedScreenViewModelType)
    
    // MARK: User
    func screenViewModelDidGetUserSettings(_ viewModel: TodayNewsFeedScreenViewModelType)
}

protocol TodayNewsFeedScreenViewModelDataSource {
    // MARK: PostComponents
    var isLoading: Bool { get }
    func postComponents(in section: Int) -> AmityPostComponent
    func numberOfPostComponents() -> Int
}

protocol TodayNewsFeedScreenViewModelAction {
    
    // MARK: Fetch data
    func fetchPosts()
    func loadMore()
    
    // MARK: PostId / CommentId
    func like(id: String, referenceType: AmityReactionReferenceType)
    func unlike(id: String, referenceType: AmityReactionReferenceType)
    
    // MARK: Post
    func delete(withPostId postId: String)
    func report(withPostId postId: String)
    func unreport(withPostId postId: String)
    func getReportStatus(withPostId postId: String)
    
    // MARK: Poll
    func vote(withPollId pollId: String?, answerIds: [String])
    func close(withPollId pollId: String?)
    
    // MARK: Observer
    func startObserveFeedUpdate()
    func stopObserveFeedUpdate()
}

protocol TodayNewsFeedScreenViewModelType: TodayNewsFeedScreenViewModelAction, TodayNewsFeedScreenViewModelDataSource {
    var delegate: TodayNewsFeedScreenViewModelDelegate? { get set }
    var action: TodayNewsFeedScreenViewModelAction { get }
    var dataSource: TodayNewsFeedScreenViewModelDataSource { get }
}

extension TodayNewsFeedScreenViewModelType {
    var action: TodayNewsFeedScreenViewModelAction { return self }
    var dataSource: TodayNewsFeedScreenViewModelDataSource { return self }
}
