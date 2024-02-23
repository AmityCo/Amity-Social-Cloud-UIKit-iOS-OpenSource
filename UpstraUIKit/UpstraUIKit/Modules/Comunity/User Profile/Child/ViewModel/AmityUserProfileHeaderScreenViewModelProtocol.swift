//
//  AmityUserProfileHeaderScreenViewModelProtocol.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 29/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityUserProfileHeaderScreenViewModelDelegate: AnyObject {
    func screenViewModel(_ viewModel: AmityUserProfileHeaderScreenViewModelType, didGetUser user: AmityUserModel)
    func screenViewModel(_ viewModel: AmityUserProfileHeaderScreenViewModelType, didGetFollowInfo followInfo: AmityFollowInfo)
    func screenViewModel(_ viewModel: AmityUserProfileHeaderScreenViewModelType, didCreateChannel channel: AmityChannel)
    func screenViewModel(_ viewModel: AmityUserProfileHeaderScreenViewModelType, didReceiveError error: AmityError)
    func screenViewModel(_ viewModel: AmityUserProfileHeaderScreenViewModelType, didFollowUser status: AmityFollowStatus, error: AmityError?)
    func screenViewModel(_ viewModel: AmityUserProfileHeaderScreenViewModelType, didUnfollowUser status: AmityFollowStatus, error: AmityError?)
    func screenViewModel(_ viewModel: AmityUserProfileHeaderScreenViewModelType, didUnblockUser error: AmityError?)
}

protocol AmityUserProfileHeaderScreenViewModelDataSource {
    var userId: String { get }
    var user: AmityUserModel? { get }
    var followInfo: AmityFollowInfo? { get }
    var followStatus: AmityFollowStatus? { get }
}

protocol AmityUserProfileHeaderScreenViewModelAction {
    func fetchUserData()
    func fetchFollowInfo()
    func createChannel()
    func follow()
    func unfollow()
    func unblockUser()
}

protocol AmityUserProfileHeaderScreenViewModelType: AmityUserProfileHeaderScreenViewModelAction, AmityUserProfileHeaderScreenViewModelDataSource {
    var action: AmityUserProfileHeaderScreenViewModelAction { get }
    var dataSource: AmityUserProfileHeaderScreenViewModelDataSource { get }
    var delegate: AmityUserProfileHeaderScreenViewModelDelegate? { get set }
}

extension AmityUserProfileHeaderScreenViewModelType {
    var action: AmityUserProfileHeaderScreenViewModelAction { return self }
    var dataSource: AmityUserProfileHeaderScreenViewModelDataSource { return self }
}
