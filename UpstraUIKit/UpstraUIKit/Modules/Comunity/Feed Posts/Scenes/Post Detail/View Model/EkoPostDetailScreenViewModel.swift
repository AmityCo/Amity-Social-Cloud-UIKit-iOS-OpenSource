//
//  EkoPostDetailScreenViewModel.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/14/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import EkoChat

final class EkoPostDetailScreenViewModel: EkoPostDetailScreenViewModelType {
    
    weak var delegate: EkoPostDetailScreenViewModelDelegate?
    
    // MARK: - Controller
    private let postController: EkoPostControllerProtocol
    private let commentController: EkoCommentControllerProtocol
    private let reactionController: EkoReactionControllerProtocol
    private let childrenController: EkoCommentChildrenController
    
    private var commentCollectionToken: EkoNotificationToken?
    private var commentCollection: EkoCollection<EkoComment>?
    
    private let postId: String
    private(set) var post: EkoPostModel?
    private var comments: [EkoCommentModel] = []
    private var viewModelArrays: [[PostDetailViewModel]] = []
    private let debouncer = Debouncer(delay: 0.3)
    
    init(withPostId postId: String,
         postController: EkoPostControllerProtocol,
         commentController: EkoCommentControllerProtocol,
         reactionController: EkoReactionControllerProtocol,
         childrenController: EkoCommentChildrenController) {
        self.postId = postId
        self.postController = postController
        self.commentController = commentController
        self.reactionController = reactionController
        self.childrenController = childrenController
    }
    
}

// MARK: - DataSource
extension EkoPostDetailScreenViewModel {
    
    func numberOfSection() -> Int {
        return viewModelArrays.count
    }
    
    func numberOfItems(_ tableView: EkoPostTableView, in section: Int) -> Int {
        let viewModels = viewModelArrays[section]
        if case .post(let postComponent) = viewModels.first(where: { $0.isPostType }) {
            // a postComponent has section/row manager, return its component count
            // a single post will be splited as 3 rows
            // example: [.post(component)] => [.header, .body, .footer]
            if let component = tableView.postDataSource?.getUIComponentForPost(post: postComponent._composable.post, at: section) {
                return component.getComponentCount(for: section)
            }
            return postComponent.getComponentCount(for: section)
        }
        return viewModels.count
    }
    
    func item(at indexPath: IndexPath) -> PostDetailViewModel {
        let viewModels = viewModelArrays[indexPath.section]
        if let index = viewModels.firstIndex(where: { $0.isPostType }) {
            // a postComponent is separated to 3 rows already
            // enforce 3 of them accessing the same index
            // example: [.header, .body, .footer] => [.post(component)]
            return viewModels[index]
        }
        return viewModels[indexPath.row]
    }
    
    private func prepareComponents(post: EkoPostModel) -> EkoPostComponent {
        post.displayType = .postDetail
        switch post.dataTypeInternal {
        case .text:
            return EkoPostComponent(component: EkoPostTextComponent(post: post))
        case .image:
            return EkoPostComponent(component: EkoPostImageComponent(post: post))
        case .file:
            return EkoPostComponent(component: EkoPostFileComponent(post: post))
        case .unknown:
            return EkoPostComponent(component: EkoPostPlaceHolderComponent(post: post))
        }
    }
    
    func getPostReportStatus() {
        postController.getReportStatus(withPostId: postId) { [weak self] (isReported) in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.screenViewModel(strongSelf, didReceiveReportStatus: isReported)
        }
    }
    
    // MARK: - Helper
    
    private func prepareData() {
        var viewModels = [[PostDetailViewModel]]()
        
        // prepare post
        if let post = post {
            if let communityId = post.communityId {
                let participation = EkoCommunityParticipation(client: UpstraUIKitManagerInternal.shared.client, andCommunityId: communityId)
                post.isModerator = participation.getMembership(post.postedUserId)?.communityRoles.contains(.moderator) ?? false
            }
            let component = prepareComponents(post: post)
            viewModels.append([.post(component)])
        }
        
        // prepare comments
        for model in comments {
            var commentsModels = [PostDetailViewModel]()
            
            // parent comment
            commentsModels.append(.comment(model))
            
            // if parent is deleted, don't show its children.
            guard !model.isDeleted else {
                viewModels.append(commentsModels)
                continue
            }
            
            // child comments
            let parentId = model.id
            var loadedItems = childrenController.childrenComments(for: parentId)
            let itemToDisplay = childrenController.numberOfDisplayingItem(for: parentId)
            let deletedItemCount = childrenController.numberOfDeletedChildren(for: parentId)
            
            // loadedItems will be empty on the first load.
            // set childrenComment directly to reduce number of server request.
            if loadedItems.isEmpty {
                loadedItems = model.childrenComment.reversed()
            }
            
            // model.childrenNumber doesn't include deleted children.
            // so, add it directly to correct the total count.
            let totalItemCount = model.childrenNumber + deletedItemCount
            let shouldShowLoadmore = itemToDisplay < totalItemCount
            let isReadyToShow = itemToDisplay <= loadedItems.count
            let isAllLoaded = loadedItems.count == totalItemCount
            
            // visible items are limited by itemToDisplay.
            // see more: ChildrenCommentsController.swift
            let postDetailViewModels: [PostDetailViewModel] = loadedItems.map({ PostDetailViewModel.replyComment($0) })
            commentsModels += Array(postDetailViewModels.prefix(itemToDisplay))
            
            if shouldShowLoadmore {
                commentsModels.append(.loadMoreReply)
            }
            if !(isReadyToShow || isAllLoaded) {
                loadChild(commentId: model.id)
            }
            
            viewModels.append(commentsModels)
        }
        
        self.viewModelArrays = viewModels
        delegate?.screenViewModelDidUpdateData(self)
    }
    
    
    private func loadChild(commentId: String) {
        childrenController.fetchChildren(for: commentId) { [weak self] in
            self?.debouncer.run {
                self?.prepareData()
            }
        }
    }

}

// MARK: - Action
extension EkoPostDetailScreenViewModel {
    
    // MARK: Post
    
    func fetchPost() {
        postController.getPostForPostId(withPostId: postId) { [weak self] (result) in
            switch result {
            case .success(let post):
                self?.post = post
                self?.debouncer.run {
                    self?.prepareData()
                }
            case .failure:
                break
            }
        }
    }
    
    func fetchComments() {
        commentController.getCommentsForPostId(withReferenceId: postId, referenceType: .post, filterByParentId: true, parentId: nil, orderBy: .descending, includeDeleted: true) { [weak self] (result) in
            switch result {
            case .success(let comments):
                self?.comments = comments
                self?.debouncer.run {
                    self?.prepareData()
                }
            case .failure:
                break
            }
        }
    }
    
    func updatePost(withText text: String) {
        postController.update(withPostId: postId, text: text) { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            if success {
                strongSelf.delegate?.screenViewModelDidUpdatePost(strongSelf)
            } else {
                strongSelf.delegate?.screenViewModel(strongSelf, didFinishWithError: EkoError(error: error) ?? .unknown)
            }
        }
    }
    
    func likePost() {
        reactionController.addReaction(withReaction: .like, referanceId: postId, referenceType: .post) { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            if success {
                strongSelf.delegate?.screenViewModelDidLikePost(strongSelf)
            } else {
                strongSelf.delegate?.screenViewModel(strongSelf, didFinishWithError: EkoError(error: error) ?? .unknown)
            }
        }
    }
    
    func unlikePost() {
        reactionController.removeReaction(withReaction: .like, referanceId: postId, referenceType: .post) { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            if success {
                strongSelf.delegate?.screenViewModelDidUnLikePost(strongSelf)
            } else {
                strongSelf.delegate?.screenViewModel(strongSelf, didFinishWithError: EkoError(error: error) ?? .unknown)
            }
        }
    }
    
    func deletePost() {
        postController.delete(withPostId: postId, parentId: nil) { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            if success {
                NotificationCenter.default.post(name: NSNotification.Name.Post.didDelete, object: nil)
            } else {
                strongSelf.delegate?.screenViewModel(strongSelf, didFinishWithError: EkoError(error: error) ?? .unknown)
            }
        }
    }
    
    func reportPost() {
        postController.report(withPostId: postId) { [weak self] (success, error) in
            self?.reportHandler(success: success, error: error)
        }
    }
    
    func unreportPost() {
        postController.unreport(withPostId: postId) { [weak self] (success, error) in
            self?.reportHandler(success: success, error: error)
        }
    }
    
    // MARK: Commend
    
    func createComment(withText text: String, parentId: String?) {
        commentController.createComment(withReferenceId: postId, referenceType: .post, parentId: parentId, text: text) { [weak self] (comment, error) in
            guard let strongSelf = self else { return }
            // check if the recent comment is contains banned word
            // if containts, delete the particular comment
            if let comment = comment, EkoError(error: error) == .bannedWord {
                strongSelf.deleteComment(with: EkoCommentModel(comment: comment))
                strongSelf.fetchComments()
                strongSelf.delegate?.screenViewModel(strongSelf, didFinishWithError: .bannedWord)
            } else {
                strongSelf.delegate?.screenViewModelDidCreateComment(strongSelf)
            }
        }
    }
    
    func deleteComment(with comment: EkoCommentModel) {
        commentController.delete(withComment: comment) { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            if success {
                strongSelf.delegate?.screenViewModelDidDeleteComment(strongSelf)
            } else {
                strongSelf.delegate?.screenViewModel(strongSelf, didFinishWithError: EkoError(error: error) ?? .unknown)
            }
        }
    }
    
    func editComment(with comment: EkoCommentModel, text: String) {
        commentController.edit(withComment: comment, text: text) { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            if success {
                strongSelf.delegate?.screenViewModelDidEditComment(strongSelf)
            } else {
                strongSelf.delegate?.screenViewModel(strongSelf, didFinishWithError: EkoError(error: error) ?? .unknown)
            }
        }
    }
    
    func likeComment(withCommendId commentId: String) {
        reactionController.addReaction(withReaction: .like, referanceId: commentId, referenceType: .comment) { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            if success {
                strongSelf.delegate?.screenViewModelDidLikeComment(strongSelf)
            } else {
                strongSelf.delegate?.screenViewModel(strongSelf, didFinishWithError: EkoError(error: error) ?? .unknown)
            }
        }
    }
    
    func unlikeComment(withCommendId commentId: String) {
        reactionController.removeReaction(withReaction: .like, referanceId: commentId, referenceType: .comment) { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            if success {
                strongSelf.delegate?.screenViewModelDidUnLikeComment(strongSelf)
            } else {
                strongSelf.delegate?.screenViewModel(strongSelf, didFinishWithError: EkoError(error: error) ?? .unknown)
            }
        }
    }
    
    func reportComment(withCommentId commentId: String) {
        commentController.report(withCommentId: commentId) { [weak self] (success, error) in
            self?.reportHandler(success: success, error: error)
        }
    }
    
    func unreportComment(withCommentId commentId: String) {
        commentController.unreport(withCommentId: commentId) { [weak self] (success, error) in
            self?.unreportHandler(success: success, error: error)
        }
    }
    
    func getCommentReportStatus(with comment: EkoCommentModel) {
        commentController.getReportStatus(withCommentId: comment.id) { [weak self] (isReported) in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.screenViewModel(strongSelf, comment: comment, didReceiveCommentReportStatus: isReported)
        }
    }
    
    func getReplyComments(at section: Int) {
        // get parent comment at section
        guard case .comment(let comment) = viewModelArrays[section].first else { return }
        childrenController.increasePageNumber(for: comment.id)
        debouncer.run { [weak self] in
            self?.prepareData()
        }
    }

    // MARK: Report handler
    
    func reportHandler(success: Bool, error: Error?) {
        if success {
            delegate?.screenViewModel(self, didFinishWithMessage: EkoLocalizedStringSet.HUD.reportSent)
        } else {
            delegate?.screenViewModel(self, didFinishWithError: EkoError(error: error) ?? .unknown)
        }
    }
    
    func unreportHandler(success: Bool, error: Error?) {
        if success {
            delegate?.screenViewModel(self, didFinishWithMessage: EkoLocalizedStringSet.HUD.unreportSent)
        } else {
            delegate?.screenViewModel(self, didFinishWithError: EkoError(error: error) ?? .unknown)
        }
    }
    
}
