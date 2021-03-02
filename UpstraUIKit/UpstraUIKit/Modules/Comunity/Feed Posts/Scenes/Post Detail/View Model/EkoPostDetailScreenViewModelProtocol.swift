//
//  EkoPostDetailScreenViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/14/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

enum PostDetailViewModel {
    
    case post(EkoPostComponent)
    case comment(EkoCommentModel)
    case replyComment(EkoCommentModel)
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

protocol EkoPostDetailScreenViewModelDelegate: class {
    // MARK: Post
    func screenViewModelDidUpdateData(_ viewModel: EkoPostDetailScreenViewModelType)
    func screenViewModelDidUpdatePost(_ viewModel: EkoPostDetailScreenViewModelType)
    func screenViewModelDidLikePost(_ viewModel: EkoPostDetailScreenViewModelType)
    func screenViewModelDidUnLikePost(_ viewModel: EkoPostDetailScreenViewModelType)
    func screenViewModel(_ viewModel: EkoPostDetailScreenViewModelType, didReceiveReportStatus isReported: Bool)
    
    // MARK: Comment
    func screenViewModelDidDeleteComment(_ viewModel: EkoPostDetailScreenViewModelType)
    func screenViewModelDidEditComment(_ viewModel: EkoPostDetailScreenViewModelType)
    func screenViewModelDidLikeComment(_ viewModel: EkoPostDetailScreenViewModelType)
    func screenViewModelDidUnLikeComment(_ viewModel: EkoPostDetailScreenViewModelType)
    func screenViewModelDidCreateComment(_ viewModel: EkoPostDetailScreenViewModelType)
    func screenViewModel(_ viewModel: EkoPostDetailScreenViewModelType, comment: EkoCommentModel, didReceiveCommentReportStatus isReported: Bool)
    func screenViewModel(_ viewModel: EkoPostDetailScreenViewModelType, didFinishWithMessage message: String)
    func screenViewModel(_ viewModel: EkoPostDetailScreenViewModelType, didFinishWithError error: EkoError)
}

protocol EkoPostDetailScreenViewModelDataSource {
    var post: EkoPostModel? { get }
    func numberOfSection() -> Int
    func numberOfItems(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> PostDetailViewModel
}

protocol EkoPostDetailScreenViewModelAction {
    
    // MARK: Fetch data
    func fetchPost()
    func fetchComments()
    
    // MARK: Post
    func updatePost(withText text: String)
    func likePost()
    func unlikePost()
    func deletePost()
    func reportPost()
    func unreportPost()
    func getPostReportStatus()
    
    // MARK: Comment
    func createComment(withText text: String, parentId: String?)
    func deleteComment(with comment: EkoCommentModel)
    func editComment(with comment: EkoCommentModel, text: String)
    func likeComment(withCommendId commentId: String)
    func unlikeComment(withCommendId commentId: String)
    func reportComment(withCommentId commentId: String)
    func unreportComment(withCommentId commentId: String)
    func getCommentReportStatus(with comment: EkoCommentModel)
    func getReplyComments(at section: Int)
}

protocol EkoPostDetailScreenViewModelType: EkoPostDetailScreenViewModelAction, EkoPostDetailScreenViewModelDataSource {
    var delegate: EkoPostDetailScreenViewModelDelegate? { get set }
    var action: EkoPostDetailScreenViewModelAction { get }
    var dataSource: EkoPostDetailScreenViewModelDataSource { get }
}

extension EkoPostDetailScreenViewModelType {
    var action: EkoPostDetailScreenViewModelAction { return self }
    var dataSource: EkoPostDetailScreenViewModelDataSource { return self }
}
