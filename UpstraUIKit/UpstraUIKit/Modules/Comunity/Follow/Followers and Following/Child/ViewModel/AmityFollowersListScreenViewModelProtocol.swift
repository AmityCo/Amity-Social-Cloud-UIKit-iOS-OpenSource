//
//  AmityFollowersListScreenViewModelProtocol.swift
//  AmityUIKit
//
//  Created by Hamlet on 14.06.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityFollowersListScreenViewModelDelegate: AnyObject {
    func screenViewModelDidGetListFail()
    func screenViewModelDidGetListSuccess()
    func screenViewModel(_ viewModel: AmityFollowersListScreenViewModelType, failure error: AmityError)
    func screenViewModel(_ viewModel: AmityFollowersListScreenViewModelType, didRemoveUser at: IndexPath)
    func screenViewModel(_ viewModel: AmityFollowersListScreenViewModelType, didReportUserSuccess at: IndexPath)
    func screenViewModel(_ viewModel: AmityFollowersListScreenViewModelType, didUnreportUserSuccess at: IndexPath)
    func screenViewModel(_ viewModel: AmityFollowersListScreenViewModelType, didGetReportUserStatus isReported: Bool, at indexPath: IndexPath)
}

protocol AmityFollowersListScreenViewModelDataSource {
    var userId: String { get }
    var isCurrentUser: Bool { get }
    var type: AmityFollowerViewType { get }
    func numberOfItems() -> Int
    func item(at indexPath: IndexPath) -> AmityUserModel?
}

protocol AmityFollowersListScreenViewModelAction {
    func getFollowsList()
    func loadMoreFollowingList()
    func reportUser(at indexPath: IndexPath)
    func removeUser(at indexPath: IndexPath)
    func unreportUser(at indexPath: IndexPath)
    func getReportUserStatus(at indexPath: IndexPath)
}

protocol AmityFollowersListScreenViewModelType: AmityFollowersListScreenViewModelAction, AmityFollowersListScreenViewModelDataSource {
    var delegate: AmityFollowersListScreenViewModelDelegate? { get set }
    var action: AmityFollowersListScreenViewModelAction { get }
    var dataSource: AmityFollowersListScreenViewModelDataSource { get }
}

extension AmityFollowersListScreenViewModelType {
    var action: AmityFollowersListScreenViewModelAction { return self }
    var dataSource: AmityFollowersListScreenViewModelDataSource { return self }
}
