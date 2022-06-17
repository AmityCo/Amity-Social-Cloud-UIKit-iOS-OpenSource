//
//  AmityPostDetailScreenViewModelProtocol.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/14/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

enum PostDetailViewModel {
    
    case post(AmityPostComponent)
    case comment(AmityCommentModel)
    case replyComment(AmityCommentModel)
    case loadMoreReply
    
    var isPostType: Bool {
        switch self {
        case .post:
            return true
        case .comment, .replyComment, .loadMoreReply:
            return false
        }
    }
    
    var isReplyType: Bool {
        switch self {
        case .replyComment:
            return true
        case .post, .comment, .loadMoreReply:
            return false
        }
    }
    
}

protocol AmityPostDetailScreenViewModelDelegate: AnyObject {
    // MARK: - Loading state
    func screenViewModel(_ viewModel: AmityPostDetailScreenViewModelType, didUpdateloadingState state: AmityLoadingState)
    
    // MARK: - Post
    func screenViewModelDidUpdateData(_ viewModel: AmityPostDetailScreenViewModelType)
    func screenViewModelDidUpdatePost(_ viewModel: AmityPostDetailScreenViewModelType)
    func screenViewModelDidLikePost(_ viewModel: AmityPostDetailScreenViewModelType)
    func screenViewModelDidUnLikePost(_ viewModel: AmityPostDetailScreenViewModelType)
    func screenViewModel(_ viewModel: AmityPostDetailScreenViewModelType, didReceiveReportStatus isReported: Bool)
    
    // MARK: - Comment
    func screenViewModelDidDeleteComment(_ viewModel: AmityPostDetailScreenViewModelType)
    func screenViewModelDidEditComment(_ viewModel: AmityPostDetailScreenViewModelType)
    func screenViewModelDidLikeComment(_ viewModel: AmityPostDetailScreenViewModelType)
    func screenViewModelDidUnLikeComment(_ viewModel: AmityPostDetailScreenViewModelType)
    func screenViewModelDidCreateComment(_ viewModel: AmityPostDetailScreenViewModelType, comment: AmityCommentModel)
    func screenViewModel(_ viewModel: AmityPostDetailScreenViewModelType, comment: AmityCommentModel, didReceiveCommentReportStatus isReported: Bool)
    func screenViewModel(_ viewModel: AmityPostDetailScreenViewModelType, didFinishWithMessage message: String)
    func screenViewModel(_ viewModel: AmityPostDetailScreenViewModelType, didFinishWithError error: AmityError)
}

protocol AmityPostDetailScreenViewModelDataSource {
    var post: AmityPostModel? { get }
    var community: AmityCommunity? { get }
    func numberOfSection() -> Int
    func numberOfItems(_ tableView: AmityPostTableView, in section: Int) -> Int
    func item(at indexPath: IndexPath) -> PostDetailViewModel
}

protocol AmityPostDetailScreenViewModelAction {
    
    // MARK: Fetch data
    func fetchPost()
    func fetchComments()
    func loadMoreComments()
    
    // MARK: Post
    func updatePost(withText text: String)
    func likePost()
    func unlikePost()
    func deletePost()
    func reportPost()
    func unreportPost()
    func getPostReportStatus()
    
    // MARK: Comment
    func createComment(withText text: String, parentId: String?, metadata: [String: Any]?, mentionees: AmityMentioneesBuilder?)
    func editComment(with comment: AmityCommentModel, text: String, metadata: [String: Any]?, mentionees: AmityMentioneesBuilder?)
    func deleteComment(with comment: AmityCommentModel)
    func likeComment(withCommendId commentId: String)
    func unlikeComment(withCommendId commentId: String)
    func reportComment(withCommentId commentId: String)
    func unreportComment(withCommentId commentId: String)
    func getCommentReportStatus(with comment: AmityCommentModel)
    func getReplyComments(at section: Int)
    
    // MARK: Poll
    func vote(withPollId pollId: String?, answerIds: [String])
    func close(withPollId pollId: String?)
}

protocol AmityPostDetailScreenViewModelType: AmityPostDetailScreenViewModelAction, AmityPostDetailScreenViewModelDataSource {
    var delegate: AmityPostDetailScreenViewModelDelegate? { get set }
    var action: AmityPostDetailScreenViewModelAction { get }
    var dataSource: AmityPostDetailScreenViewModelDataSource { get }
}

extension AmityPostDetailScreenViewModelType {
    var action: AmityPostDetailScreenViewModelAction { return self }
    var dataSource: AmityPostDetailScreenViewModelDataSource { return self }
}
