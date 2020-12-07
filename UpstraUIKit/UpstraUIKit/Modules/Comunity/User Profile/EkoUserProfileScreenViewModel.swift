//
//  EkoUserProfileScreenViewModel.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 29/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import EkoChat

final class EkoUserProfileScreenViewModel: EkoUserProfileScreenViewModelType {
    
    // MARK: - Properties
    
    let userId: String
    private let userRepository: EkoUserRepository
    private let channelRepository: EkoChannelRepository
    private var userToken: EkoNotificationToken?
    private var channelToken: EkoNotificationToken?
    
    // MARK: - Initializer
    
    init(userId: String) {
        userRepository = EkoUserRepository(client: UpstraUIKitManagerInternal.shared.client)
        channelRepository = EkoChannelRepository(client: UpstraUIKitManagerInternal.shared.client)
        self.userId = userId
    }
    
    // MARK: DataSource
    
    private var user: EkoUserModel?
    var userHeader: EkoBoxBinding<EkoUserModel?> = EkoBoxBinding(nil)
    
    func fetchUserData(completion: ((Result<EkoUserModel, Error>) -> Void)?) {
        userToken?.invalidate()
        userRepository.user(forId: userId).observe({ _,_  in })
        userToken = userRepository.user(forId: userId).observe { [weak self] object, error in
            // Due to `observeOnce` doesn't guarantee if the data is fresh or local.
            // So, this is a workaround to execute code specifically for fresh data status.
            switch object.dataStatus {
            case .fresh:
                if let user = object.object {
                    let userModel = EkoUserModel(user: user)
                    self?.user = userModel
                    completion?(.success(userModel))
                }
            case .error:
                completion?(.failure(error ?? EkoError.unknown))
            case .local, .notExist:
                break
            @unknown default:
                break
            }
        }
    }
    
}

// MARK: Action
extension EkoUserProfileScreenViewModel {
    
    func createChannel(completion: ((EkoChannel?) -> Void)?) {
        let builder = EkoConversationChannelBuilder()
        builder.setUserId(userId)
        builder.setDisplayName(user?.displayName ?? "")
        
        let channel: EkoObject<EkoChannel> = channelRepository.createConversation(with: builder)
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

