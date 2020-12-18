//
//  EkoPostDetailScreenViewModelType.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 15/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import Foundation
import EkoChat

enum PostDetailViewModel {
    case post(EkoPostModel)
    case comment(EkoCommentModel)
}

protocol EkoPostDetailScreenViewModelDataSource {
    var post: EkoPostModel? { get }
    func numberOfItems() -> Int
    func item(at index: Int) -> PostDetailViewModel
    func getReportPostStatus(postId: String, completion: ((Bool) -> Void)?)
    func getReportCommentStatus(commentId: String, completion: ((Bool) -> Void)?)
}

protocol EkoPostDetailScreenViewModelDelegate: class {
    func screenViewModelDidUpdateData(_ viewModel: EkoPostDetailScreenViewModel)
}

protocol EkoPostDetailScreenViewModelAction {
    func updatePost(text: String)
    func deletePost()
    func reportPost(postId: String)
    func unreportPost(postId: String)
    func likePost(postId: String)
    func unlikePost(postId: String)
    func createComment(text: String)
    func editComment(comment: EkoCommentModel, text: String)
    func deleteComment(comment: EkoCommentModel)
    func likeComment(commentId: String)
    func unlikeComment(commentId: String)
    func reportComment(commentId: String)
    func unreportComment(commentId: String)
}

protocol EkoPostDetailScreenViewModelType: EkoPostDetailScreenViewModelAction, EkoPostDetailScreenViewModelDataSource {
    var action: EkoPostDetailScreenViewModelAction { get }
    var dataSource: EkoPostDetailScreenViewModelDataSource { get }
    var delegate: EkoPostDetailScreenViewModelDelegate? { get set }
}

extension EkoPostDetailScreenViewModelType {
    var action: EkoPostDetailScreenViewModelAction { return self }
    var dataSource: EkoPostDetailScreenViewModelDataSource { return self }
}
