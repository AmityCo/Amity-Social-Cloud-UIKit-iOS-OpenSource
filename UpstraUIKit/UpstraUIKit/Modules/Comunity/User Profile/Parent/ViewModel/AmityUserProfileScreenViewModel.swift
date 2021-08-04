//
//  AmityUserProfileScreenViewModel.swift
//  AmityUIKit
//
//  Created by Hamlet on 15.06.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import AmitySDK

final class AmityUserProfileScreenViewModel: AmityUserProfileScreenViewModelType {
    
    weak var delegate: AmityUserProfileScreenViewModelDelegate?
    
    // MARK: - Properties
    let userId: String
    private let userRepository: AmityUserRepository
    private var userToken: AmityNotificationToken?
    
    // MARK: - Initializer
    init(userId: String) {
        userRepository = AmityUserRepository(client: AmityUIKitManagerInternal.shared.client)
        self.userId = userId
    }
    
    var isCurrentUser: Bool {
        return userId == AmityUIKitManagerInternal.shared.client.currentUserId
    }
    
}
