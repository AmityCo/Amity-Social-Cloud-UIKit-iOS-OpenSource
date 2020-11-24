//
//  EkoPostDetailScreenViewModel.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 15/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import EkoChat

class EkoPostDetailScreenViewModel: EkoPostDetailScreenViewModelType {
    
    private let feedRepository: EkoFeedRepository = EkoFeedRepository(client: UpstraUIKitManager.shared.client)
    private let reactionRepository = EkoReactionRepository(client: UpstraUIKitManager.shared.client)
    private var postObjectToken: EkoNotificationToken?
    
    private let commentRepository = EkoCommentRepository(client: UpstraUIKitManager.shared.client)
    private var commentCollectionToken: EkoNotificationToken?
    private var commentCollection: EkoCollection<EkoComment>?
    
    weak var delegate: EkoPostDetailScreenViewModelDelegate?
    private let postId: String
    private var viewModels: [PostDetailViewModel] = []
    private(set) var post: EkoPostModel?
    
    init(postId: String) {
        self.postId = postId
        postObjectToken = feedRepository.getPostForPostId(postId).observe { [weak self] postObject, _ in
            guard let post = postObject.object else { return }
            self?.post = EkoPostModel(post: post)
            self?.prepareData()
        }
        commentCollection = commentRepository.comments(withReferenceId: postId, referenceType: .post, filterByParentId: false, parentId: nil, orderBy: .ascending, includeDeleted: true)
        commentCollectionToken = commentCollection?.observe { [weak self] collection, _, error in
            self?.prepareData()
        }
    }
    
    // MARK: - Datasource
    
    private func prepareData() {
        guard let collection = commentCollection else { return }
        var viewModels = [PostDetailViewModel]()
        
        // post
        if let post = post {
            viewModels = [.post(post)]
        }
        
        // comment
        for i in 0..<collection.count() {
            guard let comment = collection.object(at: i) else { return }
            let model = EkoCommentModel(comment: comment)
            viewModels.append(.comment(model))
        }
        
        self.viewModels = viewModels
        delegate?.screenViewModelDidUpdateData(self)
    }
    
    func numberOfItems() -> Int {
        return viewModels.count
    }
    
    func item(at index: Int) -> PostDetailViewModel {
        return viewModels[index]
    }
    
    // MARK: - Action
    
    func updatePost(text: String) {
        let textBuilder = EkoTextPostBuilder()
        textBuilder.setText(text)
        feedRepository.updatePost(withPostId: postId, builder: textBuilder, completion: nil)
    }
    
    func deletePost() {
        feedRepository.deletePost(withPostId: postId, parentId: nil) { _, _ in
            NotificationCenter.default.post(name: NSNotification.Name.Post.didDelete, object: nil)
        }
    }
    
    func createComment(text: String) {
        commentRepository.createComment(withReferenceId: postId, referenceType: .post, parentId: nil, text: text)
    }
    
    func editComment(comment: EkoCommentModel, text: String) {
        let commentEditor = EkoCommentEditor(client: UpstraUIKitManager.shared.client, comment: comment.comment)
        commentEditor.editText(text, completion: { (success, error) in
            // Do something with success
        })
    }
    
    func deleteComment(comment: EkoCommentModel) {
        let commentEditor = EkoCommentEditor(client: UpstraUIKitManager.shared.client, comment: comment.comment)
        commentEditor.delete(completion: { (success, _) in
            // Do something with success
        })
    }
    
    func likePost(postId: String) {
        reactionRepository.addReaction("like", referenceId: postId, referenceType: .post, completion: nil)
    }
    
    func unlikePost(postId: String) {
        reactionRepository.removeReaction("like", referenceId: postId, referenceType: .post, completion: nil)
    }
    
    func likeComment(commentId: String) {
        reactionRepository.addReaction("like", referenceId: commentId, referenceType: .comment, completion: nil)
    }
    
    func unlikeComment(commentId: String) {
        reactionRepository.removeReaction("like", referenceId: commentId, referenceType: .comment, completion: nil)
    }
    
}
