//
//  AmityUserProfileScreenViewModelProtocol.swift
//  AmityUIKit
//
//  Created by Hamlet on 15.06.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityUserProfileScreenViewModelDelegate: AnyObject {
    func screenViewModel(_ viewModel: AmityUserProfileScreenViewModelType, failure error: AmityError)
}

protocol AmityUserProfileScreenViewModelDataSource {
    var userId: String { get }
    var isCurrentUser: Bool { get }
}

protocol AmityUserProfileScreenViewModelAction {
}

protocol AmityUserProfileScreenViewModelType: AmityUserProfileScreenViewModelDataSource, AmityUserProfileScreenViewModelAction {
    var dataSource: AmityUserProfileScreenViewModelDataSource { get }
    var action: AmityUserProfileScreenViewModelAction { get }
    var delegate: AmityUserProfileScreenViewModelDelegate? { set get }
}

extension AmityUserProfileScreenViewModelType {
    var dataSource: AmityUserProfileScreenViewModelDataSource { return self }
    var action: AmityUserProfileScreenViewModelAction { return self }
}
