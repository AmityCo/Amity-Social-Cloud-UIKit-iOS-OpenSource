//
//  AmityTrueEventHandler.swift
//  AmityUIKit
//
//  Created by Mono TheForestcat on 8/2/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

public class AmityCreateChannelHandler {
    public static let shared = AmityCreateChannelHandler()
    private var channelToken: AmityNotificationToken?
    private var userToken: AmityNotificationToken?
    private var existingChannelToken: AmityNotificationToken?
    private var channelRepository: AmityChannelRepository?
    private var userRepository: AmityUserRepository?
    private var roleController: AmityChannelRoleController?
    
    public init() {
        channelRepository = AmityChannelRepository(client: AmityUIKitManagerInternal.shared.client)
        userRepository = AmityUserRepository(client: AmityUIKitManagerInternal.shared.client)
    }
    
    public func createChannel(trueUser: TrueUser, completion: @escaping(Result<String,Error>) -> ()) {
        getOtherUserDisplayName(userId: trueUser.userId){ result in
            switch result {
            case .success(let displayName):
                let userFromTrue = TrueUser(userId: trueUser.userId, displayName: displayName)
                let users = [userFromTrue]
                var allUsers = users
                var currentUser: TrueUser?
                if let user = AmityUIKitManagerInternal.shared.client.currentUser?.object {
                    let userModel = TrueUser(userId: user.userId, displayName: user.displayName ?? "")
                    currentUser = userModel
                    allUsers.append(userModel)
                }
                let builder = AmityConversationChannelBuilder()
                let userIds = allUsers.map{ $0.userId }
                let channelId = "\(userIds.sorted().joined(separator: "-"))_CONVER"
                let channelDisplayName = users.count == 1 ? users.first?.displayName ?? "" : allUsers.map { $0.displayName ?? "" }.joined(separator: "-")
                var userArrayWithDisplayName: [String] = []
                for name in allUsers{
                    userArrayWithDisplayName.append("\(name.userId):\(name.displayName ?? "")")
                }
                builder.setUserIds(userIds)
                let metaData: [String:Any] = [
                    "isDirectChat": allUsers.count == 2,
                    "creatorId": currentUser?.userId ?? "",
                    "sdk_type":"ios",
                    "userIds": userIds,
                    "chatDisplayName": userArrayWithDisplayName
                ]
                builder.setMetadata(metaData)
                builder.setDisplayName(channelDisplayName)
                builder.setTags(["ch-comm","ios-sdk"])
                self.existingChannelToken?.invalidate()
                self.existingChannelToken = self.channelRepository?.getChannel(channelId).observe({ [weak self] (channel, error) in
                    guard let weakSelf = self else { return }
                    if error != nil {
                        weakSelf.createNewConversationChannel(builder: builder) { result in
                            switch result {
                            case .success(let channelId):
                                completion(.success(channelId))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    }
                    guard channel.object != nil else { return }
                    weakSelf.channelRepository?.joinChannel(channelId)
                    weakSelf.existingChannelToken?.invalidate()
                    completion(.success(channelId))
                })
            case .failure(let error):
                print("Error on create chat: \(error.localizedDescription)")
            }
        }
        
    }
    
    public func createChatFromContactPage(trueUser: TrueUser, completion: @escaping(Result<String,Error>) -> ()) {
        getOtherUserDisplayName(userId: trueUser.userId){ result in
            switch result {
            case .success(let displayName):
                let userFromTrue = TrueUser(userId: trueUser.userId, displayName: displayName)
                let users = [userFromTrue]
                var allUsers = users
                var currentUser: TrueUser?
                if let user = AmityUIKitManagerInternal.shared.client.currentUser?.object {
                    let userModel = TrueUser(userId: user.userId, displayName: user.displayName ?? "")
                    currentUser = userModel
                    allUsers.append(userModel)
                }
                let builder = AmityConversationChannelBuilder()
                let userIds = allUsers.map{ $0.userId }
                let channelId = "\(userIds.sorted().joined(separator: "-"))_CONVER"
                let channelDisplayName = users.count == 1 ? users.first?.displayName ?? "" : allUsers.map { $0.displayName ?? "" }.joined(separator: "-")
                var userArrayWithDisplayName: [String] = []
                for name in allUsers{
                    userArrayWithDisplayName.append("\(name.userId):\(name.displayName ?? "")")
                }
                builder.setUserIds(userIds)
                let metaData: [String:Any] = [
                    "isDirectChat": allUsers.count == 2,
                    "creatorId": currentUser?.userId ?? "",
                    "sdk_type":"ios",
                    "userIds": userIds,
                    "chatDisplayName": userArrayWithDisplayName
                ]
                builder.setMetadata(metaData)
                builder.setDisplayName(channelDisplayName)
                builder.setTags(["ch-comm","ios-sdk"])
                self.existingChannelToken?.invalidate()
                self.existingChannelToken = self.channelRepository?.getChannel(channelId).observe({ [weak self] (channel, error) in
                    guard let weakSelf = self else { return }
                    if error != nil {
                        weakSelf.createNewConversationChannel(builder: builder) { result in
                            switch result {
                            case .success(let channelId):
                                completion(.success(channelId))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    }
                    guard channel.object != nil else { return }
                    weakSelf.channelRepository?.joinChannel(channelId)
                    weakSelf.existingChannelToken?.invalidate()
                    completion(.success(channelId))
                })
            case .failure(let error):
                print("Error on create chat: \(error.localizedDescription)")
            }
        }
        
    }
    
    func createNewConversationChannel(builder: AmityConversationChannelBuilder, completion: @escaping(Result<String,Error>) -> ()) {
        let channelObject = channelRepository?.createChannel(with: builder)
        channelToken?.invalidate()
        channelToken = channelObject?.observe {[weak self] channelObject, error in
            guard let weakSelf = self else { return }
            if let error = error {
                completion(.failure(error))
                AmityHUD.show(.error(message: error.localizedDescription))
            }
            if let channelId = channelObject.object?.channelId {
                weakSelf.channelToken?.invalidate()
                completion(.success(channelId))
            }
        }
    }
    
    func getOtherUserDisplayName(userId: String, completion: @escaping(Result<String,Error>) -> ()) {
        userToken = userRepository?.getUser(userId).observe{ [weak self] user, error in
            if error != nil {
                completion(.failure(error!))
            }
            if let userObject = user.object {
                let userModel = AmityUserModel(user: userObject)
                let displayName = userModel.displayName
                self?.userToken?.invalidate()
                completion(.success(displayName))
            }
        }
    }

}
