//
//  EkoFeedScreenViewModel.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/13/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoFeedScreenViewModel: EkoFeedScreenViewModelType {
    
    // MARK: - Delegate
    weak var delegate: EkoFeedScreenViewModelDelegate?
    
    // MARK: - Controller
    private let postController: EkoPostControllerProtocol
    private let commentController: EkoCommentControllerProtocol
    private let reactionController: EkoReactionControllerProtocol
    
    // MARK: - Properties
    private let feedType: EkoPostFeedType
    private var postComponents = [EkoPostComponent]()
    
    init(withFeedType feedType: EkoPostFeedType,
        postController: EkoPostControllerProtocol,
        commentController: EkoCommentControllerProtocol,
        reactionController: EkoReactionControllerProtocol) {
        self.feedType = feedType
        self.postController = postController
        self.commentController = commentController
        self.reactionController = reactionController
    }
    
}

// MARK: - DataSource

// MARK: Post component
extension EkoFeedScreenViewModel {
    
    func getFeedType() -> EkoPostFeedType {
        return feedType
    }
    
    func postComponents(in section: Int) -> EkoPostComponent {
        return postComponents[section - 1]
    }
    
    // Plus 1 is for the header view section
    // We can be enhanced later
    func numberOfPostComponents() -> Int {
        return postComponents.count + 1
    }
    
    private func prepareComponents(posts: [EkoPostModel]) {
        postComponents = []
        for post in posts {
            post.displayType = .feed
            switch post.dataTypeInternal {
            case .text:
                addComponent(component: EkoPostTextComponent(post: post))
            case .image:
                addComponent(component: EkoPostImageComponent(post: post))
            case .file:
                addComponent(component: EkoPostFileComponent(post: post))
            case .unknown:
                addComponent(component: EkoPostPlaceHolderComponent(post: post))
            }
        }
        delegate?.screenViewModelDidUpdateDataSuccess(self)
    }

    private func addComponent(component: EkoPostComposable) {
        postComponents.append(EkoPostComponent(component: component))
    }
}

// MARK: - Action
// MARK: Fetch data
extension EkoFeedScreenViewModel {
    
    func fetchPosts() {
        postController.fetch(withFeedType: feedType) { [weak self] (result) in
            switch result {
            case .success(let posts):
                self?.prepareComponents(posts: posts)
            case .failure(let error):
                break
            }
        }
    }
    
    func loadMore() {
        let canLoadmore = postController.loadMore()
        if canLoadmore {
            delegate?.screenViewModelLoadingState(self, for: .loadmore)
        } else {
            delegate?.screenViewModelLoadingState(self, for: .loaded)
        }
    }
    
    func reload() {
        fetchPosts()
    }
}

// MARK: Observer
extension EkoFeedScreenViewModel {
    func startObserveFeedUpdate() {
        NotificationCenter.default.addObserver(self, selector: #selector(feedNeedsUpdate(_:)), name: Notification.Name.Post.didCreate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(feedNeedsUpdate(_:)), name: Notification.Name.Post.didUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(feedNeedsUpdate(_:)), name: Notification.Name.Post.didDelete, object: nil)
    }
    
    func stopObserveFeedUpdate() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.Post.didCreate, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.Post.didUpdate, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.Post.didDelete, object: nil)
    }
    
    @objc private func feedNeedsUpdate(_ notification: NSNotification) {
        // Feed can't get notified from SDK after posting because backend handles a query step.
        // So, it needs to be notified from our side over NotificationCenter.
        reload()
        if notification.name == Notification.Name.Post.didCreate {
            delegate?.screenViewModelScrollToTop(self)
        }
    }
}

// MARK: Post&Comment
extension EkoFeedScreenViewModel {
    func like(id: String, referenceType: EkoReactionReferenceType) {
        reactionController.addReaction(withReaction: .like, referanceId: id, referenceType: referenceType) { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            if success {
                switch referenceType {
                case .post:
                    strongSelf.delegate?.screenViewModelDidLikePostSuccess(strongSelf)
                case .comment:
                    strongSelf.delegate?.screenViewModelDidLikeCommentSuccess(strongSelf)
                default:
                    break
                }
            } else {
                strongSelf.delegate?.screenViewModelDidFail(strongSelf, failure: EkoError(error: error) ?? .unknown)
            }
        }
    }
    
    func unlike(id: String, referenceType: EkoReactionReferenceType) {
        reactionController.removeReaction(withReaction: .like, referanceId: id, referenceType: referenceType) { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            if success {
                switch referenceType {
                case .post:
                    strongSelf.delegate?.screenViewModelDidUnLikePostSuccess(strongSelf)
                case .comment:
                    strongSelf.delegate?.screenViewModelDidUnLikeCommentSuccess(strongSelf)
                default:
                    break
                }
            } else {
                strongSelf.delegate?.screenViewModelDidFail(strongSelf, failure: EkoError(error: error) ?? .unknown)
            }
        }
    }
    
}

// MARK: Post
extension EkoFeedScreenViewModel {
    func delete(withPostId postId: String) {
        postController.delete(withPostId: postId, parentId: nil) { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            if success {
                NotificationCenter.default.post(name: NSNotification.Name.Post.didDelete, object: nil)
            } else {
                strongSelf.delegate?.screenViewModelDidFail(strongSelf, failure: EkoError(error: error) ?? .unknown)
            }
        }
    }
    
    func report(withPostId postId: String) {
        postController.report(withPostId: postId)  { [weak self] (success, error) in
            self?.reportHandler(success: success, error: error)
        }
    }
    
    func unreport(withPostId postId: String) {
        postController.unreport(withPostId: postId) { [weak self] (success, error) in
            self?.unreportHandler(success: success, error: error)
        }
    }

    func getReportStatus(withPostId postId: String) {
        postController.getReportStatus(withPostId: postId) { [weak self] (isReported) in
            self?.delegate?.screenViewModelDidGetReportStatusPost(isReported: isReported)
        }
    }
}

// MARK: Comment
extension EkoFeedScreenViewModel {
    func delete(withComment comment: EkoCommentModel) {
        commentController.delete(withComment: comment) { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            if success {
                strongSelf.delegate?.screenViewModelDidDeleteCommentSuccess(strongSelf)
            } else {
                strongSelf.delegate?.screenViewModelDidFail(strongSelf, failure: EkoError(error: error) ?? .unknown)
            }
        }
    }
    
    func edit(withComment comment: EkoCommentModel, text: String) {
        commentController.edit(withComment: comment, text: text) { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            if success {
                strongSelf.delegate?.screenViewModelDidEditCommentSuccess(strongSelf)
            } else {
                strongSelf.delegate?.screenViewModelDidFail(strongSelf, failure: EkoError(error: error) ?? .unknown)
            }
        }
    }
    
    func report(withCommentId commentId: String) {
        commentController.report(withCommentId: commentId) { [weak self] (success, error) in
            self?.reportHandler(success: success, error: error)
        }
    }
    
    func unreport(withCommentId commentId: String) {
        commentController.unreport(withCommentId: commentId) { [weak self] (success, error) in
            self?.unreportHandler(success: success, error: error)
        }
    }
    
    
    func getReportStatus(withCommendId commendId: String, completion: @escaping (Bool) -> Void) {
        commentController.getReportStatus(withCommentId: commendId, completion: completion)
    }
}

// MARK: Report handler
private extension EkoFeedScreenViewModel {
    func reportHandler(success: Bool, error: Error?) {
        if success {
            delegate?.screenViewModelDidSuccess(self, message: EkoLocalizedStringSet.HUD.reportSent)
        } else {
            delegate?.screenViewModelDidFail(self, failure: EkoError(error: error) ?? .unknown)
        }
    }
    
    func unreportHandler(success: Bool, error: Error?) {
        if success {
            delegate?.screenViewModelDidSuccess(self, message: EkoLocalizedStringSet.HUD.unreportSent)
        } else {
            delegate?.screenViewModelDidFail(self, failure: EkoError(error: error) ?? .unknown)
        }
    }
}

// This is a simple NSCache based cache used for caching images. This might not be suitable for caching lots of images that we need to handle
// in UIKit. Please look into combining Disk & In-Memory based cache for optimizing performance.
class EkoImageCache {
    let cache = NSCache<AnyObject, AnyObject>()
    
    func getImage(key: String) -> UIImage? {
        let image = cache.object(forKey: key as AnyObject) as? UIImage
        return image
    }
    
    func setImage(key: String, value: UIImage) {
        cache.setObject(value, forKey: key as AnyObject)
    }
}
