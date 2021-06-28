//
//  AmityUserProfileScreenViewModelProtocol.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 29/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityUserProfileScreenViewModelDataSource {
    var userId: String { get }
    func fetchUserData(completion: ((Result<AmityUserModel, Error>) -> Void)?)
}

protocol AmityUserProfileScreenViewModelAction {
    func createChannel(completion: ((AmityChannel?) -> Void)?)
}

protocol AmityUserProfileScreenViewModelType: AmityUserProfileScreenViewModelAction, AmityUserProfileScreenViewModelDataSource {
    var action: AmityUserProfileScreenViewModelAction { get }
    var dataSource: AmityUserProfileScreenViewModelDataSource { get }
}

extension AmityUserProfileScreenViewModelType {
    var action: AmityUserProfileScreenViewModelAction { return self }
    var dataSource: AmityUserProfileScreenViewModelDataSource { return self }
}


