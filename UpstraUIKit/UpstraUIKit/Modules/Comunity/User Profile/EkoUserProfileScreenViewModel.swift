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
        userRepository = EkoUserRepository(client: UpstraUIKitManager.shared.client)
        channelRepository = EkoChannelRepository(client: UpstraUIKitManager.shared.client)
        self.userId = userId
    }
    
    // MARK: DataSource
    
    var user: EkoBoxBinding<EkoUserModel?> = EkoBoxBinding(nil)
    #warning("workaround for observing data on header")
    var userHeader: EkoBoxBinding<EkoUserModel?> = EkoBoxBinding(nil)
    var channel: EkoBoxBinding<EkoChannel?> = EkoBoxBinding(nil)
    
}

// MARK: Action
extension EkoUserProfileScreenViewModel {
    
    func getInfo() {
        userToken = userRepository.user(forId: userId).observe { [weak self] object, _ in
            guard let user = object.object else { return }
            let userModel = EkoUserModel(user: user)
            self?.user.value = userModel
            self?.userHeader.value = userModel
        }
    }
    
    func createChannel() {
        let builder = EkoConversationChannelBuilder()
        builder.setUserId(userId)
        builder.setDisplayName(user.value?.displayName ?? "")
        
        let channelObject: EkoObject<EkoChannel> = channelRepository.createConversation(with: builder)
        channelToken = channelObject.observeOnce { [weak self] channelObject, _ in
            switch channelObject.dataStatus {
            case .local, .fresh:
                self?.channel.value = channelObject.object
            case .error, .notExist:
                break
            @unknown default:
                break
            }
        }
    }
    
}
