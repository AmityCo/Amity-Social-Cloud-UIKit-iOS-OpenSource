//
//  AmityUserFollowersScreenViewModel.swift
//  AmityUIKit
//
//  Created by Hamlet on 27.06.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import AmitySDK

final class AmityUserFollowersScreenViewModel: AmityUserFollowersScreenViewModelType {
    
    weak var delegate: AmityUserFollowersScreenViewModelDelegate?
    
    // MARK: - Properties
    let userId: String
    private(set) var user: AmityUserModel?
    private let userRepository: AmityUserRepository
    private var userToken: AmityNotificationToken?
    
    init(userId: String) {
        userRepository = AmityUserRepository(client: AmityUIKitManagerInternal.shared.client)
        self.userId = userId
    }
}

// MARK: Action
extension AmityUserFollowersScreenViewModel {
    func getUser() {
        userToken?.invalidate()
        userToken = userRepository.getUser(userId).observe { [weak self] object, error in
            guard let strongSelf = self else { return }
            switch object.dataStatus {
            case .fresh:
                if let user = object.object {
                    let userModel = AmityUserModel(user: user)
                    strongSelf.user = userModel
                    strongSelf.delegate?.screenViewModel(strongSelf, didGetUser: userModel)
                }
            case .error:
                strongSelf.delegate?.screenViewModel(strongSelf, failure: AmityError(error: error) ?? .unknown)
            case .local, .notExist:
                break
            @unknown default:
                break
            }
        }
    }
}
