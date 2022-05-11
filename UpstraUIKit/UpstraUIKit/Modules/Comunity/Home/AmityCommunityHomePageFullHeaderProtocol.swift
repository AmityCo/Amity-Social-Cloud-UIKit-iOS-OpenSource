//
//  AmityCommunityHomePageFullHeaderProtocol.swift
//  AmityUIKit
//
//  Created by Mono TheForestcat on 11/4/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityCommunityHomePageFullHeaderScreenViewModelDelegate: AnyObject {
    func screenViewModel(_ viewModel: AmityCommunityHomePageFullHeaderScreenViewModelType, failure error: AmityError)
    func didFetchUserProfile(user: AmityUser)
}

protocol AmityCommunityHomePageFullHeaderScreenViewModelDataSource {
    var userId: String { get }
    var isCurrentUser: Bool { get }
    var amityCommunityEventTypeModel: AmityCommunityEventTypeModel? { get set }
}

protocol AmityCommunityHomePageFullHeaderScreenViewModelAction {
    func fetchUserProfile(with userId: String)
}

protocol AmityCommunityHomePageFullHeaderScreenViewModelType: AmityCommunityHomePageFullHeaderScreenViewModelDataSource, AmityCommunityHomePageFullHeaderScreenViewModelAction {
    var dataSource: AmityCommunityHomePageFullHeaderScreenViewModelDataSource { get }
    var action: AmityCommunityHomePageFullHeaderScreenViewModelAction { get }
    var delegate: AmityCommunityHomePageFullHeaderScreenViewModelDelegate? { set get }
}

extension AmityCommunityHomePageFullHeaderScreenViewModelType {
    var dataSource: AmityCommunityHomePageFullHeaderScreenViewModelDataSource { return self }
    var action: AmityCommunityHomePageFullHeaderScreenViewModelAction { return self }
}
