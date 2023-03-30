//
//  AmityPendingPostsDetailScreenViewModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 12/5/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

final class AmityPendingPostsDetailScreenViewModel: AmityPendingPostsDetailScreenViewModelType {
    
    weak var delegate: AmityPendingPostsDetailScreenViewModelDelegate?
    
    // MARK: - Repository
    private let communityRepository: AmityCommunityRepository
    private let postRepository: AmityPostRepository
    
    // MARK: - Tasks
    private let communityViewModel: AmityPendingPostsCommunityViewModelProtocol
    private let postViewModel: AmityPendingPostsDetailGetPostViewModelProtocol
    
    // MARK: - Properties
    private let postId: String
    private var post: AmityPostModel?
    private var postComponent: AmityPostComponent?
    private var community: AmityCommunityModel?
    private(set) var memberStatusCommunity: AmityMemberStatusCommunity = .guest
    let communityId: String
    
    // MARK: - Initial
    init(communityId: String, postId: String) {
        self.communityId = communityId
        self.postId = postId
        self.communityRepository = AmityCommunityRepository(client: AmityUIKitManagerInternal.shared.client)
        self.postRepository = AmityPostRepository(client: AmityUIKitManagerInternal.shared.client)
        self.communityViewModel = AmityPendingPostsCommunityViewModel(communityId: communityId, communityRepository: communityRepository)
        self.postViewModel = AmityPendingPostsDetailGetPostViewModel()
    }
}

// MARK: - DataSource
extension AmityPendingPostsDetailScreenViewModel{
    func numberOfPostComponents() -> Int {
        return postComponent?.getComponentCount(for: 0) ?? 0
    }
    
    func postComponents(at indexPath: IndexPath) -> AmityPostComponent? {
        return postComponent
    }
}

// MARK: - Action
extension AmityPendingPostsDetailScreenViewModel {
    
    func getMemberStatus() {
        communityViewModel.getMemberStatus { [weak self] (community, status) in
            guard let strongSelf = self else { return }
            strongSelf.community = community
            strongSelf.memberStatusCommunity = status
            strongSelf.delegate?.screenViewModel(strongSelf, didGetMemberStatusCommunity: status)
        }
    }
    
    func getPost() {
        postViewModel.getPostForPostId(withPostId: postId) { [weak self] (result) in
            switch result {
            case .success(let post):
                self?.post = post
                self?.preparePostComponent(post: post)
            case .failure(let error):
                break
            }
        }
    }
    
    private func preparePostComponent(post: AmityPostModel) {
        let component = AmityPendingPostsComponent(post: post, hasEditCommunityPermission: memberStatusCommunity == .admin)
        post.appearance.displayType = .postDetail
        post.appearance.shouldShowCommunityName = false
        postComponent = AmityPostComponent(component: component)
        
        delegate?.screenViewModelDidGetPost(self)
    }
    
    func approvePost() {
        postRepository.approvePost(withId: postId, completion: { [weak self] (success, error)in
            self?.delegate?.screenViewModelDidApproveOrDeclinePost()
        })
    }
    
    func declinePost() {
        postRepository.declinePost(withId: postId, completion: { [weak self] (success, error) in
            self?.delegate?.screenViewModelDidApproveOrDeclinePost()
        })
    }
    
    func deletePost() {
        postViewModel.getPostForPostId(withPostId: postId) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let post):
                switch post.feedType {
                case .published, .declined:
                    strongSelf.delegate?.screenViewModelDidDeletePostFail(title: AmityLocalizedStringSet.PendingPosts.postNotAvailable.localizedString,
                                                                          message: AmityLocalizedStringSet.PendingPosts.alertDeleteFailApproveOrDecline.localizedString)
                case .reviewing:
                    self?.postRepository.deletePost(withId: strongSelf.postId, parentId: nil, hardDelete: false, completion: { _, _ in
                        self?.delegate?.screenViewModelDidDeletePostFinish()
                    })
                @unknown default:
                    break
                }
            case .failure:
                strongSelf.delegate?.screenViewModelDidDeletePostFail(title: AmityLocalizedStringSet.PendingPosts.alertDeleteFailTitle.localizedString,
                                                                      message: AmityLocalizedStringSet.somethingWentWrongWithTryAgain.localizedString)
            }
        }
    }
}
