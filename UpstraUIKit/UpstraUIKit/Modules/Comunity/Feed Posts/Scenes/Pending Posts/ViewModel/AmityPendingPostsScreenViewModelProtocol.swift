//
//  AmityPendingPostsScreenViewModelProtocol.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 19/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

protocol AmityPendingPostsScreenViewModelDelegate: AnyObject {
    func screenViewModel(_ viewModel: AmityPendingPostsScreenViewModelType, didGetMemberStatusCommunity status: AmityMemberStatusCommunity)
    func screenViewModelDidGetPendingPosts(_ viewModel: AmityPendingPostsScreenViewModelType)
    func screenViewModel(_ viewModel: AmityPendingPostsScreenViewModelType, didFail error: AmityError)
    func screenViewModelDidDeletePostFail(title: String, message: String)
}

protocol AmityPendingPostsScreenViewModelDataSource {
    var communityId: String { get }
    var memberStatusCommunity: AmityMemberStatusCommunity { get }
    
    func postComponents(in section: Int) -> AmityPostComponent
    func numberOfPostComponents() -> Int
    func numberOfItemComponents(_ tableView: AmityPostTableView, in section: Int) -> Int
    
}

protocol AmityPendingPostsScreenViewModelAction {
    func getMemberStatus()
    func getPendingPosts()
    
    func approvePost(withPostId postId: String)
    func declinePost(withPostId postId: String)
    func deletePost(withPostId postId: String)
}

protocol AmityPendingPostsScreenViewModelType: AmityPendingPostsScreenViewModelAction, AmityPendingPostsScreenViewModelDataSource {
    var delegate: AmityPendingPostsScreenViewModelDelegate? { get set }
    var action: AmityPendingPostsScreenViewModelAction { get }
    var dataSource: AmityPendingPostsScreenViewModelDataSource { get }
}

extension AmityPendingPostsScreenViewModelType {
    var action: AmityPendingPostsScreenViewModelAction { return self }
    var dataSource: AmityPendingPostsScreenViewModelDataSource { return self }
}

