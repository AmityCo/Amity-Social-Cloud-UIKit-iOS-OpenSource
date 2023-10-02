//
//  AmityCommunityMemberScreenViewModelProtocol.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 15/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityCommunityMemberScreenViewModelDelegate: AnyObject {
    func screenViewModelDidGetMember()
    func screenViewModel(_ viewModel: AmityCommunityMemberScreenViewModel, loadingState state: AmityLoadingState)
    func screenViewModel(_ viewModel: AmityCommunityMemberScreenViewModel, didRemoveUserAt indexPath: IndexPath)
    func screenViewModelDidAddMemberSuccess()
    func screenViewModelDidAddRoleSuccess()
    func screenViewModelDidRemoveRoleSuccess()
    func screenViewModel(_ viewModel: AmityCommunityMemberScreenViewModel, failure error: AmityError)
    
}

protocol AmityCommunityMemberScreenViewModelDataSource {
    var community: AmityCommunityModel { get }
    func numberOfMembers() -> Int
    func member(at indexPath: IndexPath) -> AmityCommunityMembershipModel
    func getReportUserStatus(at indexPath: IndexPath, completion: ((Bool) -> Void)?)
    func prepareData() -> [AmitySelectMemberModel]
    func getCommunityEditUserPermission(_ completion: ((Bool) -> Void)?)
}

protocol AmityCommunityMemberScreenViewModelAction {
    func getMember(viewType: AmityCommunityMemberViewType)
    func loadMore()
    func addUser(users: [AmitySelectMemberModel])
    func removeUser(at indexPath: IndexPath)
    func reportUser(at indexPath: IndexPath)
    func unreportUser(at indexPath: IndexPath)
    func addRole(at indexPath: IndexPath)
    func removeRole(at indexPath: IndexPath)
}

protocol AmityCommunityMemberScreenViewModelType: AmityCommunityMemberScreenViewModelAction, AmityCommunityMemberScreenViewModelDataSource {
    var delegate: AmityCommunityMemberScreenViewModelDelegate? { get set }
    var action: AmityCommunityMemberScreenViewModelAction { get }
    var dataSource: AmityCommunityMemberScreenViewModelDataSource { get }
}

extension AmityCommunityMemberScreenViewModelType {
    var action: AmityCommunityMemberScreenViewModelAction { return self }
    var dataSource: AmityCommunityMemberScreenViewModelDataSource { return self }
}
