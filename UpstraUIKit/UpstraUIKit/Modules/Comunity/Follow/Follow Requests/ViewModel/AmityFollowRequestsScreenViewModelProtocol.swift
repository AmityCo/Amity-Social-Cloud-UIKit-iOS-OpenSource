//
//  AmityFollowRequestsScreenViewModelProtocol.swift
//  AmityUIKit
//
//  Created by Hamlet on 17.05.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityFollowRequestsScreenViewModelDelegate: AnyObject {
    func screenViewModelDidGetRequests()
    func screenViewModel(_ viewModel: AmityFollowRequestsScreenViewModel, loadingState state: AmityLoadingState)
    func screenViewModel(_ viewModel: AmityFollowRequestsScreenViewModel, didAcceptRequestAt indexPath: IndexPath)
    func screenViewModel(_ viewModel: AmityFollowRequestsScreenViewModel, didDeclineRequestAt indexPath: IndexPath)
    func screenViewModel(_ viewModel: AmityFollowRequestsScreenViewModel, didFailToAcceptRequestAt indexPath: IndexPath)
    func screenViewModel(_ viewModel: AmityFollowRequestsScreenViewModel, didFailToDeclineRequestAt indexPath: IndexPath)
    func screenViewModel(_ viewModel: AmityFollowRequestsScreenViewModel, didRemoveRequestAt indexPath: IndexPath)
    func screenViewModel(_ viewModel: AmityFollowRequestsScreenViewModel, failure error: AmityError)
}

protocol AmityFollowRequestsScreenViewModelDataSource {
    var userId: String { get }
    func numberOfRequests() -> Int
    func item(at indexPath: IndexPath) -> AmityFollowRelationship
}

protocol AmityFollowRequestsScreenViewModelAction {
    func getFollowRequests()
    func acceptRequest(at indexPath: IndexPath)
    func declineRequest(at indexPath: IndexPath)
    func removeRequest(at indexPath: IndexPath)
    func reload()
}

protocol AmityFollowRequestsScreenViewModelType: AmityFollowRequestsScreenViewModelAction, AmityFollowRequestsScreenViewModelDataSource {
    var delegate: AmityFollowRequestsScreenViewModelDelegate? { get set }
    var action: AmityFollowRequestsScreenViewModelAction { get }
    var dataSource: AmityFollowRequestsScreenViewModelDataSource { get }
}

extension AmityFollowRequestsScreenViewModelType {
    var action: AmityFollowRequestsScreenViewModelAction { return self }
    var dataSource: AmityFollowRequestsScreenViewModelDataSource { return self }
}
