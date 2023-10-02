//
//  AmityChannelAddMemberController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 22/12/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

enum AmityChannelAddMemberError {
    case addMemberFailure(AmityError?)
    case removeMemberFailure(AmityError?)
}

protocol AmityChannelAddMemberControllerProtocol {
    func add(currentUsers: [AmityChannelMembershipModel], newUsers users: [AmitySelectMemberModel], _ completion: @escaping (AmityError?, AmityChannelAddMemberError?) -> Void)
}

final class AmityChannelAddMemberController: AmityChannelAddMemberControllerProtocol {
    
    private var membershipParticipation: AmityChannelParticipation?
    
    private var queue = DispatchGroup()
    private var addMemberError: AmityError?
    private var removeMemberError: AmityError?
    
    init(channelId: String) {
        membershipParticipation = AmityChannelParticipation(client: AmityUIKitManagerInternal.shared.client, andChannel: channelId)
    }
    
    deinit {
        membershipParticipation = nil
    }
    
    func add(currentUsers: [AmityChannelMembershipModel], newUsers users: [AmitySelectMemberModel], _ completion: @escaping (AmityError?, AmityChannelAddMemberError?) -> Void) {
        // get userId
        let currentUserIds = currentUsers.filter { !$0.isCurrentUser}.map { $0.userId }
        let newUserIds = users.map { $0.userId }
        
        // filter userid it has been removed
        let difRemoveUsers = currentUserIds.filter { !newUserIds.contains($0) }
        // filter userid has been added
        let difAddUsers = newUserIds.filter { !currentUserIds.contains($0) }
        
        addUsers(userIds: difAddUsers)
        removeUsers(userIds: difRemoveUsers)
        
        queue.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else { return }
            let _addMemberError = strongSelf.addMemberError
            let _removeMemberError = strongSelf.removeMemberError
            
            if (_addMemberError != nil) && (_removeMemberError != nil), (_addMemberError == _removeMemberError) {
                // failure both cases add and remove member and same case
                completion(_addMemberError, nil)
            } else if (_addMemberError != nil) && (_removeMemberError == nil) {
                // failure only case add member
                (completion(nil, .addMemberFailure(_addMemberError)))
            } else if (_removeMemberError != nil) && (_addMemberError == nil) {
                (completion(nil, .removeMemberFailure(_removeMemberError)))
            } else {
                // success both cases
                completion(nil, nil)
            }
            self?.addMemberError = nil
            self?.removeMemberError = nil
        }
    }
    
    private func addUsers(userIds: [String]) {
        if !userIds.isEmpty {
            queue.enter()
            membershipParticipation?.addMembers(userIds, completion: { [weak self] (success, error) in
                if success {
                    self?.addMemberError = nil
                } else {
                    self?.removeMemberError = AmityError(error: error) ?? .unknown
                }
                self?.queue.leave()
            })
        }
    }
    
    private func removeUsers(userIds: [String]) {
        if !userIds.isEmpty {
            queue.enter()
            membershipParticipation?.removeMembers(userIds, completion: { [weak self] (success, error) in
                if success {
                    self?.removeMemberError = nil
                } else {
                    self?.removeMemberError = AmityError(error: error) ?? .unknown
                }
                self?.queue.leave()
            })
        }
    }
}
