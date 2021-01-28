//
//  EkoPostDetailScreenViewModel.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 15/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import EkoChat

class EkoPostDetailScreenViewModel: EkoPostDetailScreenViewModelType {
    
    private let feedRepository: EkoFeedRepository = EkoFeedRepository(client: UpstraUIKitManagerInternal.shared.client)
    private let reactionRepository = EkoReactionRepository(client: UpstraUIKitManagerInternal.shared.client)
    private var postFlagger: EkoPostFlagger?
    private var postObjectToken: EkoNotificationToken?
    
    private let commentRepository = EkoCommentRepository(client: UpstraUIKitManagerInternal.shared.client)
    private var commentFlagger: EkoCommentFlagger?
    private var commentCollectionToken: EkoNotificationToken?
    private var commentCollection: EkoCollection<EkoComment>?
    private var createCommentToken: EkoNotificationToken?
    
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
        setupCollection()
    }
    
    private func setupCollection() {
        commentCollectionToken?.invalidate()
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
            if let communityId = post.communityId {
                let participation = EkoCommunityParticipation(client: UpstraUIKitManagerInternal.shared.client, andCommunityId: communityId)
                post.isModerator = participation.getMembership(post.postedUserId)?.communityRoles.contains(.moderator) ?? false
            }
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
    
    func getReportPostStatus(postId: String, completion: ((Bool) -> Void)?) {
        postFlagger = EkoPostFlagger(client: UpstraUIKitManagerInternal.shared.client, postId: postId)
        postFlagger?.isPostFlaggedByMe {
            completion?($0)
        }
    }
    
    func getReportCommentStatus(commentId: String, completion: ((Bool) -> Void)?) {
        commentFlagger = EkoCommentFlagger(client: UpstraUIKitManagerInternal.shared.client, commentId: commentId)
        commentFlagger?.isFlagByMe {
            completion?($0)
        }
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
    
    func reportPost(postId: String) {
        let flagger = EkoPostFlagger(client: UpstraUIKitManagerInternal.shared.client, postId: postId)
        flagger.flagPost { (success, error) in
            if let error = error {
                EkoHUD.show(.error(message: error.localizedDescription))
            } else {
                EkoHUD.show(.success(message: EkoLocalizedStringSet.HUD.reportSent.localizedString))
            }
        }
    }
    
    func unreportPost(postId: String) {
        let flagger = EkoPostFlagger(client: UpstraUIKitManagerInternal.shared.client, postId: postId)
        flagger.unflagPost { (success, error) in
            if let error = error {
                EkoHUD.show(.error(message: error.localizedDescription))
            } else {
                EkoHUD.show(.success(message: EkoLocalizedStringSet.HUD.unreportSent.localizedString))
            }
        }
    }
    
    func createComment(text: String) {
        createCommentToken?.invalidate()
        createCommentToken = commentRepository.createComment(withReferenceId: postId, referenceType: .post, parentId: nil, text: text).observe { [weak self] object, error in
            // check if the recent comment is contains banned word
            // if containts, delete the particular comment
            if let comment = object.object, EkoError(error: error) == .bannedWord {
                self?.deleteComment(comment: EkoCommentModel(comment: comment))
                self?.setupCollection()
                EkoHUD.show(.error(message: EkoLocalizedStringSet.PostDetail.banndedCommentErrorMessage.localizedString))
            }
        }
    }
    
    func editComment(comment: EkoCommentModel, text: String) {
        let commentEditor = EkoCommentEditor(client: UpstraUIKitManagerInternal.shared.client, comment: comment.comment)
        commentEditor.editText(text, completion: { (success, error) in
            // Do something with success
        })
    }
    
    func deleteComment(comment: EkoCommentModel) {
        let commentEditor = EkoCommentEditor(client: UpstraUIKitManagerInternal.shared.client, comment: comment.comment)
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
    
    func reportComment(commentId: String) {
        commentFlagger = EkoCommentFlagger(client: UpstraUIKitManagerInternal.shared.client, commentId: commentId)
        commentFlagger?.flag { (success, error) in
            if let error = error {
                EkoHUD.show(.error(message: error.localizedDescription))
            } else {
                EkoHUD.show(.success(message: EkoLocalizedStringSet.HUD.reportSent.localizedString))
            }
        }
    }
    
    func unreportComment(commentId: String) {
        commentFlagger = EkoCommentFlagger(client: UpstraUIKitManagerInternal.shared.client, commentId: commentId)
        commentFlagger?.unflag { (success, error) in
            if let error = error {
                EkoHUD.show(.error(message: error.localizedDescription))
            } else {
                EkoHUD.show(.success(message: EkoLocalizedStringSet.HUD.unreportSent.localizedString))
            }
        }
    }
    
}
