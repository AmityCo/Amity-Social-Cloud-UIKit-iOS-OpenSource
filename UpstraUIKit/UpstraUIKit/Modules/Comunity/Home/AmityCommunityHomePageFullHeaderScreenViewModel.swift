//
//  AmityCommunityHomePageFullHeaderScreenViewModel.swift
//  AmityUIKit
//
//  Created by Mono TheForestcat on 11/4/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import AmitySDK

final class AmityCommunityHomePageFullHeaderScreenViewModel: AmityCommunityHomePageFullHeaderScreenViewModelType {
    
    weak var delegate: AmityCommunityHomePageFullHeaderScreenViewModelDelegate?
    
    // MARK: - Properties
    let userId: String
    private let userRepository: AmityUserRepository
    private var userToken: AmityNotificationToken?
    var amityCommunityEventTypeModel: AmityCommunityEventTypeModel?

    // MARK: - Initializer
    init(amityCommunityEventTypeModel: AmityCommunityEventTypeModel? = nil) {
        userRepository = AmityUserRepository(client: AmityUIKitManagerInternal.shared.client)
        self.userId = AmityUIKitManagerInternal.shared.client.currentUserId ?? ""
        self.amityCommunityEventTypeModel = amityCommunityEventTypeModel
    }
    
    var isCurrentUser: Bool {
        return userId == AmityUIKitManagerInternal.shared.client.currentUserId
    }
    
    func fetchUserProfile(with userId: String) {
        userToken?.invalidate()
        userToken = userRepository.getUser(userId).observe { [weak self] object, error in
            self?.userToken?.invalidate()
            guard let user = object.object else { return }
            self?.delegate?.didFetchUserProfile(user: user)
        }
    }
    
}
