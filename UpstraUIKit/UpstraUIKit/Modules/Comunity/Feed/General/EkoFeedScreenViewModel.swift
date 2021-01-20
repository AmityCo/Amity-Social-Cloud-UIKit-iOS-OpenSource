//
//  EkoFeedScreenViewModel.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 6/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import EkoChat

enum FeedViewModel {
    case post(EkoPostModel)
}

class EkoFeedScreenViewModel: EkoFeedScreenViewModelType {
    
    weak var delegate: EkoFeedScreenViewModelDelegate?
    
    private let feedRepository = EkoFeedRepository(client: UpstraUIKitManagerInternal.shared.client)
    private let fileRepository = EkoFileRepository(client: UpstraUIKitManagerInternal.shared.client)
    private let reactionRepository = EkoReactionRepository(client: UpstraUIKitManagerInternal.shared.client)
    private var communityParticipation: EkoCommunityParticipation?
    private var postFlagger: EkoPostFlagger?
    private var commentFlagger: EkoCommentFlagger?
    private var feedCollection: EkoCollection<EkoPost>?
    private var feedToken: EkoNotificationToken?
    private var communityTokens: [String: EkoNotificationToken] = [:]
    
    // Map between communityId and moderator user id
    // in order to check if user is the moderator in the particular community
    //
    // Example: [ "communityId" : ["user_a", "user_b"] ]
    // * This means user_a and user_b are both moderators
    private var moderatorMap: [String: Set<String>] = [:]
    
    private var imageCache = EkoImageCache()
    private var viewModels: [FeedViewModel] = []
    let feedType: FeedType
    
    // MARK: - Initializer
    
    init(feedType: FeedType) {
        self.feedType = feedType
        setupCollection()
    }
    
    private func setupCollection() {
        switch feedType {
        case .globalFeed:
            feedCollection = feedRepository.getGlobalFeed()
        case .myFeed:
            feedCollection = feedRepository.getMyFeedSorted(by: .lastCreated, includeDeleted: false)
        case .userFeed(let userId):
            // If current userId is passing through .userFeed, handle this case as .myFeed type.
            if userId == UpstraUIKitManagerInternal.shared.client.currentUserId {
                feedCollection = feedRepository.getMyFeedSorted(by: .lastCreated, includeDeleted: false)
            } else {
                feedCollection = feedRepository.getUserFeed(userId, sortBy: .lastCreated, includeDeleted: false)
            }
        case .communityFeed(let communityId):
            feedCollection = feedRepository.getCommunityFeed(withCommunityId: communityId, sortBy: .lastCreated, includeDeleted: false)
        }
        
        feedToken?.invalidate()
        feedToken = feedCollection?.observe { [weak self] (collection, change, error) in
            self?.prepareDataSource()
            Log.add("Feed collection error: \(String(describing: error))")
        }
    }
    
    private func prepareDataSource() {
        guard let collection = feedCollection else { return }
        
        var postModels = [EkoPostModel]()
        for i in 0..<collection.count() {
            guard let post = collection.object(at: i) else { continue }
            let model = EkoPostModel(post: post)
            if let communityId = model.communityId {
                communityParticipation = EkoCommunityParticipation(client: UpstraUIKitManagerInternal.shared.client, andCommunityId: communityId)
                let roles = communityParticipation?.getMembership(post.postedUserId)?.roles as? [String] ?? []
                model.isModerator = roles.contains("moderator")
            }
            postModels.append(model)
        }
        viewModels = postModels.map { .post($0) }
        delegate?.screenViewModelDidUpdateData(self)
    }
    
    // MARK: - DataSource
    
    func numberOfItems() -> Int {
        return viewModels.count
    }
    
    func item(at indexPath: IndexPath) -> FeedViewModel {
        return viewModels[indexPath.row]
    }
    
    func loadNext() {
        guard let collection = feedCollection else { return }
        switch collection.loadingStatus {
        case .loaded:
            collection.nextPage()
        default:
            break
        }
    }
    
    func reloadData() {
        setupCollection()
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
    
    func likePost(postId: String) {
        reactionRepository.addReaction("like", referenceId: postId, referenceType: .post, completion: nil)
    }
    
    func unlikePost(postId: String) {
        reactionRepository.removeReaction("like", referenceId: postId, referenceType: .post, completion: nil)
    }
    
    func deletePost(postId: String) {
        feedRepository.deletePost(withPostId: postId, parentId: nil) { _, _ in
            NotificationCenter.default.post(name: NSNotification.Name.Post.didCreate, object: nil)
        }
    }
    
    func reportPost(postId: String) {
        postFlagger = EkoPostFlagger(client: UpstraUIKitManagerInternal.shared.client, postId: postId)
        postFlagger?.flagPost { (success, error) in
            if let error = error {
                EkoHUD.show(.error(message: error.localizedDescription))
            } else {
                EkoHUD.show(.success(message: EkoLocalizedStringSet.HUD.reportSent.localizedString))
            }
        }
    }
    
    func unreportPost(postId: String) {
        postFlagger = EkoPostFlagger(client: UpstraUIKitManagerInternal.shared.client, postId: postId)
        postFlagger?.unflagPost { (success, error) in
            if let error = error {
                EkoHUD.show(.error(message: error.localizedDescription))
            } else {
                EkoHUD.show(.success(message: EkoLocalizedStringSet.HUD.unreportSent.localizedString))
            }
        }
    }
    
    func likeComment(commentId: String) {
        reactionRepository.addReaction("like", referenceId: commentId, referenceType: .comment, completion: nil)
    }
    
    func unlikeComment(commentId: String) {
        reactionRepository.removeReaction("like", referenceId: commentId, referenceType: .comment, completion: nil)
    }
    
    func deleteComment(comment: EkoCommentModel) {
        let commentEditor = EkoCommentEditor(client: UpstraUIKitManagerInternal.shared.client, comment: comment.comment)
        commentEditor.delete(completion:  nil)
    }
    
    func editComment(comment: EkoCommentModel, text: String) {
        let commentEditor = EkoCommentEditor(client: UpstraUIKitManagerInternal.shared.client, comment: comment.comment)
        commentEditor.editText(text, completion: nil)
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
