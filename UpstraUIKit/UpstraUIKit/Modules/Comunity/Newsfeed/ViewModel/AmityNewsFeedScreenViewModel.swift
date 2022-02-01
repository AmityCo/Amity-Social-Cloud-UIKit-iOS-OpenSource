//
//  AmityNewsFeedScreenViewModel.swift
//  AmityUIKit
//
//  Created by PrInCeInFiNiTy on 1/2/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation
import AmitySDK

class AmityNewsFeedScreenViewModel: AmityNewsFeedScreenViewModelType {

    weak var delegate: AmityNewsFeedScreenViewModelDelegate?
    
    private var userToken: AmityNotificationToken?
    private let userRepository: AmityUserRepository
    
    init() {
        userRepository = AmityUserRepository(client: AmityUIKitManagerInternal.shared.client)
    }
    
}

// MARK: - Action
extension AmityNewsFeedScreenViewModel {
    
    func fetchUserProfile(with userId: String) {
        userToken?.invalidate()
        userToken = userRepository.getUser(userId).observe { [weak self] object, error in
            self?.userToken?.invalidate()
            guard let user = object.object else { return }
            self?.delegate?.didFetchUserProfile(user: user)
        }
    }
    
}
