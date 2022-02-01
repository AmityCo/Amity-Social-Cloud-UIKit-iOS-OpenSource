//
//  AmityNewsFeedScreenViewModelType.swift
//  AmityUIKit
//
//  Created by PrInCeInFiNiTy on 1/2/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation
import AmitySDK

protocol AmityNewsFeedScreenViewModelDelegate: AnyObject {
    func didFetchUserProfile(user: AmityUser)
}

protocol AmityNewsFeedScreenViewModelAction {
    func fetchUserProfile(with userId: String)
}

protocol AmityNewsFeedScreenViewModelType: AmityNewsFeedScreenViewModelAction {
    var action: AmityNewsFeedScreenViewModelAction { get }
    var delegate: AmityNewsFeedScreenViewModelDelegate? { get set }
}

extension AmityNewsFeedScreenViewModelType {
    var action: AmityNewsFeedScreenViewModelAction { return self }
}
