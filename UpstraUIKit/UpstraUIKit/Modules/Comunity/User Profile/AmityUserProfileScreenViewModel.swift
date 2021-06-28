//
//  AmityUserProfileScreenViewModel.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 29/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import AmitySDK

final class AmityUserProfileScreenViewModel: AmityUserProfileScreenViewModelType {
    
    // MARK: - Properties
    
    let userId: String
    private let userRepository: AmityUserRepository
    private let channelRepository: AmityChannelRepository
    private var userToken: AmityNotificationToken?
    private var channelToken: AmityNotificationToken?
    
    // MARK: - Initializer
    
    init(userId: String) {
        userRepository = AmityUserRepository(client: AmityUIKitManagerInternal.shared.client)
        channelRepository = AmityChannelRepository(client: AmityUIKitManagerInternal.shared.client)
        self.userId = userId
    }
    
    // MARK: DataSource
    
    private var user: AmityUserModel?
    var userHeader: AmityBoxBinding<AmityUserModel?> = AmityBoxBinding(nil)
    
    func fetchUserData(completion: ((Result<AmityUserModel, Error>) -> Void)?) {
        userToken?.invalidate()
        userRepository.getUser(userId).observe({ _,_  in })
        userToken = userRepository.getUser(userId).observe { [weak self] object, error in
            // Due to `observeOnce` doesn't guarantee if the data is fresh or local.
            // So, this is a workaround to execute code specifically for fresh data status.
            switch object.dataStatus {
            case .fresh:
                if let user = object.object {
                    let userModel = AmityUserModel(user: user)
                    self?.user = userModel
                    completion?(.success(userModel))
                }
            case .error:
                completion?(.failure(error ?? AmityError.unknown))
            case .local, .notExist:
                break
            @unknown default:
                break
            }
        }
    }
    
}

// MARK: Action
extension AmityUserProfileScreenViewModel {
    
    func createChannel(completion: ((AmityChannel?) -> Void)?) {
        let builder = AmityConversationChannelBuilder()
        builder.setUserId(userId)
        builder.setDisplayName(user?.displayName ?? "")
        
        let channel: AmityObject<AmityChannel> = channelRepository.createChannel().conversation(with: builder)
        channelToken?.invalidate()
        channelToken = channel.observeOnce { channelObject, _ in
            switch channelObject.dataStatus {
            case .local, .fresh:
                completion?(channelObject.object)
            case .error, .notExist:
                break
            @unknown default:
                break
            }
        }
    }
    
}

