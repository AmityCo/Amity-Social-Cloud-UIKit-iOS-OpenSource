//
//  AmityUserFollowersScreenViewModelProtocol.swift
//  AmityUIKit
//
//  Created by Hamlet on 27.06.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import Foundation

protocol AmityUserFollowersScreenViewModelDelegate: AnyObject {
    func screenViewModel(_ viewModel: AmityUserFollowersScreenViewModelType, failure error: AmityError)
    func screenViewModel(_ viewModel: AmityUserFollowersScreenViewModelType, didGetUser user: AmityUserModel)
}

protocol AmityUserFollowersScreenViewModelDataSource {
    var userId: String { get }
    var user: AmityUserModel? { get }
}

protocol AmityUserFollowersScreenViewModelAction {
    func getUser()
}

protocol AmityUserFollowersScreenViewModelType: AmityUserFollowersScreenViewModelAction, AmityUserFollowersScreenViewModelDataSource {
    var delegate: AmityUserFollowersScreenViewModelDelegate? { get set }
    var action: AmityUserFollowersScreenViewModelAction { get }
    var dataSource: AmityUserFollowersScreenViewModelDataSource { get }
}

extension AmityUserFollowersScreenViewModelType {
    var action: AmityUserFollowersScreenViewModelAction { return self }
    var dataSource: AmityUserFollowersScreenViewModelDataSource { return self }
}
