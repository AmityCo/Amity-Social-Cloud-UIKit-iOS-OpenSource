//
//  TodayNewsFeedScreenViewModelType.swift
//  AmityUIKit
//
//  Created by Jiratin Teean on 8/7/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

final class TodayNewsFeedScreenViewModel : TodayNewsFeedScreenViewModelType {
   
   // MARK: - Delegate
   weak var delegate: TodayNewsFeedScreenViewModelDelegate?
   
   // MARK: - Controller
   private let postController: AmityPostControllerProtocol
   private let reactionController: AmityReactionControllerProtocol
   private let pollRepository: AmityPollRepository
   
   // MARK: - Properties
   private let debouncer = Debouncer(delay: 0.3)
   private var postComponents = [AmityPostComponent]()
   private var pinPostComponents = [AmityPostComponent]()
   private(set) var isPrivate: Bool
   private(set) var isLoading: Bool {
       didSet {
           guard oldValue != isLoading else { return }
           delegate?.screenViewModelLoadingStatusDidChange(self, isLoading: isLoading)
       }
   }
       
   init(postController: AmityPostControllerProtocol,
       reactionController: AmityReactionControllerProtocol) {
       self.postController = postController
       self.reactionController = reactionController
       self.isPrivate = false
       self.isLoading = false
       self.pollRepository = AmityPollRepository(client: AmityUIKitManagerInternal.shared.client)
   }
   
}

// MARK: - DataSource
extension TodayNewsFeedScreenViewModel {
   
   func postComponents(in section: Int) -> AmityPostComponent {
       return postComponents[section]
   }
   
   // We can be enhanced later
   func numberOfPostComponents() -> Int {
       return postComponents.count
   }
   
   private func prepareComponents(posts: [AmityPostModel]) {
       postComponents = []
       postComponents = pinPostComponents
       
       for post in posts {
           post.appearance.displayType = .feed
           switch post.dataTypeInternal {
           case .text:
               addComponent(component: AmityPostTextComponent(post: post))
           case .image, .video:
               addComponent(component: AmityPostMediaComponent(post: post))
           case .file:
               addComponent(component: AmityPostFileComponent(post: post))
           case .poll:
               addComponent(component: AmityPostPollComponent(post: post))
           case .liveStream:
               addComponent(component: AmityPostLiveStreamComponent(post: post))
           case .unknown:
               addComponent(component: AmityPostPlaceHolderComponent(post: post))
           }
       }
       isLoading = false
       delegate?.screenViewModelDidUpdateDataSuccess(self)
   }
   
   private func prepareComponentsPinPost(posts: AmityPostModel?) {
       pinPostComponents = []
       
       guard let post = posts else {
           return
       }
       post.appearance.displayType = .feed
       switch post.dataTypeInternal {
       case .text:
           addComponent(component: AmityPostTextComponent(post: post))
       case .image, .video:
           addComponent(component: AmityPostMediaComponent(post: post))
       case .file:
           addComponent(component: AmityPostFileComponent(post: post))
       case .poll:
           addComponent(component: AmityPostPollComponent(post: post))
       case .liveStream:
           addComponent(component: AmityPostLiveStreamComponent(post: post))
       case .unknown:
           addComponent(component: AmityPostPlaceHolderComponent(post: post))
       }
   }

   private func addComponent(component: AmityPostComposable) {
       postComponents.append(AmityPostComponent(component: component))
   }
   
   private func addPinPostComponent(component: AmityPostComposable) {
       pinPostComponents.append(AmityPostComponent(component: component))
   }
}

// MARK: - Action
// MARK: Fetch data
extension TodayNewsFeedScreenViewModel {
   
   func fetchPosts() {
       isLoading = true
//       customAPIRequest.getPinPostData() { postArray in
       //               self.prepareComponentsPinPost(posts: nil)
       //               guard let postsData = postArray else { return }
       let postsData = ["62c26cf28e566400d9275a6e",
                        "62a0d00a3b84c800da2660fc",
                        "62c26c82951bd700d9688973",
                        "62c274d469d26400d8888533",
                        "62c53a2ac5ac1900d9e854af",
                        "62c45c4bd21c5100d9446a7e",
                        "62c4451329941b00d9761802",
                        "62c4483ed65f1c00d9163d0c",
                        "62c62a564aeb6800da5a0732",
                        "62c5aa2504d39000d911de5b"]
       
//       var postObj: AmityPostModel = AmityPostModel(post: AmityPost())
//       postObj.postId = "123"
//       postObj.latestComments = post.latestComments.map(AmityCommentModel.init)
//       postObj.dataType = post.dataType
//       postObj.targetId = post.targetId
//       postObj.targetCommunity = post.targetCommunity
//       postObj.childrenPosts = post.childrenPosts ?? []
//       postObj.parentPostId = post.parentPostId
//       postObj.postedUser = Author(
//           avatarURL: post.postedUser?.getAvatarInfo()?.fileURL,
//           customAvatarURL: post.postedUser?.avatarCustomUrl,
//           displayName: post.postedUser?.displayName ?? AmityLocalizedStringSet.General.anonymous.localizedString, isGlobalBan: post.postedUser?.isGlobalBan ?? false)
//       postObj.subtitle = post.isEdited ? String.localizedStringWithFormat(AmityLocalizedStringSet.PostDetail.postDetailCommentEdit.localizedString, post.createdAt.relativeTime) : post.createdAt.relativeTime
//       postObj.postedUserId = post.postedUserId
//       postObj.sharedCount = Int(post.sharedCount)
//       postObj.reactionsCount = Int(post.reactionsCount)
//       postObj.allCommentCount = Int(post.commentsCount)
//       postObj.allReactions = post.myReactions
//       postObj.myReactions = allReactions.compactMap(AmityReactionType.init)
//       postObj.feedType = post.getFeedType()
//       postObj.data = post.data ?? [:]
//       postObj.appearance = AmityPostAppearance()
//       postObj.poll = post.getPollInfo().map(Poll.init)
//       postObj. metadata = post.metadata
//       postObj.mentionees = post.mentionees
        
       var postArray: [AmityPostModel] = []
       for postId in postsData {
           //Get Pin-post data
           self.postController.getPostForPostId(withPostId: postId, isPin: true) { [weak self] (result) in
               guard let strongSelf = self else { return }
               switch result {
               case .success(let post):
                   post.latestComments = []
                   postArray.append(post)
                   print("----> \(postArray.count)")
                   //                       strongSelf.prepareComponentsPinPost(posts: post)
               case .failure(let error):
                   if let amityError = AmityError(error: error), amityError == .noUserAccessPermission {
                       strongSelf.isPrivate = false
                       strongSelf.debouncer.run {
                           strongSelf.prepareComponents(posts: [])
                       }
                       strongSelf.delegate?.screenViewModelDidFail(strongSelf, failure: amityError)
                   } else {
                       strongSelf.delegate?.screenViewModelDidFail(strongSelf, failure: AmityError(error: error) ?? .unknown)
                   }
               }
           }
           
           self.prepareComponents(posts: postArray)
       }
   }
   
   func loadMore() {
       postController.loadMore()
   }
   
}

// MARK: Observer
extension TodayNewsFeedScreenViewModel {
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
       fetchPosts()
       if notification.name == Notification.Name.Post.didCreate {
           delegate?.screenViewModelScrollToTop(self)
       }
       
       if notification.name == Notification.Name.Post.didDelete {
           delegate?.screenViewModelDidDelete()
       }
   }
}

// MARK: Post&Comment
extension TodayNewsFeedScreenViewModel {
   func like(id: String, referenceType: AmityReactionReferenceType) {
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
               strongSelf.delegate?.screenViewModelDidFail(strongSelf, failure: AmityError(error: error) ?? .unknown)
           }
       }
   }
   
   func unlike(id: String, referenceType: AmityReactionReferenceType) {
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
               strongSelf.delegate?.screenViewModelDidFail(strongSelf, failure: AmityError(error: error) ?? .unknown)
           }
       }
   }
   
}

// MARK: Post
extension TodayNewsFeedScreenViewModel {
   func delete(withPostId postId: String) {
       AmityHUD.show(.loading)
       postController.delete(withPostId: postId, parentId: nil) { [weak self] (success, error) in
           guard let strongSelf = self else { return }
           AmityHUD.hide()
           if success {
               NotificationCenter.default.post(name: NSNotification.Name.Post.didDelete, object: nil)
           } else {
               strongSelf.delegate?.screenViewModelDidFail(strongSelf, failure: AmityError(error: error) ?? .unknown)
           }
           PTNToast.share.present(title: "Post has been deleted")
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

// MARK: Report handler
private extension TodayNewsFeedScreenViewModel {
   func reportHandler(success: Bool, error: Error?) {
       if success {
           delegate?.screenViewModelDidSuccess(self, message: AmityLocalizedStringSet.HUD.reportSent)
       } else {
           delegate?.screenViewModelDidFail(self, failure: AmityError(error: error) ?? .unknown)
       }
   }
   
   func unreportHandler(success: Bool, error: Error?) {
       if success {
           delegate?.screenViewModelDidSuccess(self, message: AmityLocalizedStringSet.HUD.unreportSent)
       } else {
           delegate?.screenViewModelDidFail(self, failure: AmityError(error: error) ?? .unknown)
       }
   }
}

// MARK: Poll
extension TodayNewsFeedScreenViewModel {
   
   func vote(withPollId pollId: String?, answerIds: [String]) {
       guard let pollId = pollId else { return }
       pollRepository.votePoll(withId: pollId, answerIds: answerIds) { [weak self] success, error in
           guard let strongSelf = self else { return }
           
           Log.add("[Poll] Vote Poll: \(success) Error: \(error)")
           if success {
               
           } else {
               strongSelf.delegate?.screenViewModelDidFail(strongSelf, failure: AmityError(error: error) ?? .unknown)
           }
       }
   }
   
   func close(withPollId pollId: String?) {
       guard let pollId = pollId else { return }
       pollRepository.closePoll(withId: pollId) { [weak self] success, error in
           guard let strongSelf = self else { return }
           if success {
               
           } else {
               strongSelf.delegate?.screenViewModelDidFail(strongSelf, failure: AmityError(error: error) ?? .unknown)
           }
       }
   }
   
}
