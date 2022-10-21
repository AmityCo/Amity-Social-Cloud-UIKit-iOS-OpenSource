//
//  AmityChannelMemberScreenViewModelProtocol.swift
//  AmityUIKit
//
//  Created by Min Khant on 15/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityChannelMemberScreenViewModelDelegate: AnyObject {
    func screenViewModelDidGetMember()
    func screenViewModel(_ viewModel: AmityChannelMemberScreenViewModel, loadingState state: AmityLoadingState)
    func screenViewModel(_ viewModel: AmityChannelMemberScreenViewModel, didRemoveUserAt indexPath: IndexPath)
    func screenViewModelDidAddMemberSuccess()
    func screenViewModelDidAddRoleSuccess()
    func screenViewModelDidRemoveMemberSuccess()
    func screenViewModelDidRemoveRoleSuccess()
    func screenViewModelDidSearchUser()
    func screenViewModel(_ viewModel: AmityChannelMemberScreenViewModel, failure error: AmityError)
    
}

protocol AmityChannelMemberScreenViewModelDataSource {
    var channel: AmityChannelModel { get }
    func numberOfMembers() -> Int
    func member(at indexPath: IndexPath) -> AmityChannelMembershipModel
    func getReportUserStatus(at indexPath: IndexPath, completion: ((Bool) -> Void)?)
    func prepareData() -> [AmitySelectMemberModel]
    func getChannelEditUserPermission(_ completion: ((Bool) -> Void)?)
}

protocol AmityChannelMemberScreenViewModelAction {
    func getMember(viewType: AmityChannelMemberViewType)
    func loadMore()
    func addUser(users: [AmitySelectMemberModel])
    func removeUser(at indexPath: IndexPath)
    func reportUser(at indexPath: IndexPath)
    func unreportUser(at indexPath: IndexPath)
    func addRole(at indexPath: IndexPath)
    func removeRole(at indexPath: IndexPath)
    func searchUser(with searchText: String)
}

protocol AmityChannelMemberScreenViewModelType: AmityChannelMemberScreenViewModelAction, AmityChannelMemberScreenViewModelDataSource {
    var delegate: AmityChannelMemberScreenViewModelDelegate? { get set }
    var action: AmityChannelMemberScreenViewModelAction { get }
    var dataSource: AmityChannelMemberScreenViewModelDataSource { get }
}

extension AmityChannelMemberScreenViewModelType {
    var action: AmityChannelMemberScreenViewModelAction { return self }
    var dataSource: AmityChannelMemberScreenViewModelDataSource { return self }
}
