//
//  EkoCommunityMemberScreenViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 15/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoCommunityMemberScreenViewModelDelegate: class {
    func screenViewModelDidGetMember()
    func screenViewModelLoadingState(state: EkoLoadingState)
    func screenViewModelDidRemoveUser(at indexPath: IndexPath)
    func screenViewModelDidAddMember(success: Bool)
    func screenViewModelFailure()
}

protocol EkoCommunityMemberScreenViewModelDataSource {
    func numberOfMembers() -> Int
    func member(at indexPath: IndexPath) -> EkoCommunityMembershipModel
    func getReportUserStatus(at indexPath: IndexPath, completion: ((Bool) -> Void)?)
    var isModerator: Bool { get }
    func prepareData() -> [EkoSelectMemberModel]
    func isJoined() -> Bool
}

protocol EkoCommunityMemberScreenViewModelAction {
    func getCommunity()
    func getMember(viewType: EkoCommunityMemberViewType)
    func getUserIsModerator()
    func loadMore()
    func addUser(users: [EkoSelectMemberModel])
    func removeUser(at indexPath: IndexPath)
    func reportUser(at indexPath: IndexPath)
    func unreportUser(at indexPath: IndexPath)
    func addRole(at indexPath: IndexPath)
    func removeRole(at indexPath: IndexPath)
}

protocol EkoCommunityMemberScreenViewModelType: EkoCommunityMemberScreenViewModelAction, EkoCommunityMemberScreenViewModelDataSource {
    var delegate: EkoCommunityMemberScreenViewModelDelegate? { get set }
    var action: EkoCommunityMemberScreenViewModelAction { get }
    var dataSource: EkoCommunityMemberScreenViewModelDataSource { get }
}

extension EkoCommunityMemberScreenViewModelType {
    var action: EkoCommunityMemberScreenViewModelAction { return self }
    var dataSource: EkoCommunityMemberScreenViewModelDataSource { return self }
}
