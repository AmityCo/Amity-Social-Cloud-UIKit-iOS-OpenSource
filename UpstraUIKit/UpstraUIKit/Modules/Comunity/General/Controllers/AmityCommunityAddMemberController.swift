//
//  AmityCommunityAddMemberController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 22/12/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

enum AmityCommunityAddMemberError {
    case addMemberFailure(AmityError?)
    case removeMemberFailure(AmityError?)
}

protocol AmityCommunityAddMemberControllerProtocol {
    func add(currentUsers: [AmityCommunityMembershipModel], newUsers users: [AmitySelectMemberModel], _ completion: @escaping (AmityError?, AmityCommunityAddMemberError?) -> Void)
}

final class AmityCommunityAddMemberController: AmityCommunityAddMemberControllerProtocol {
    
    private var membershipParticipation: AmityCommunityParticipation?
    
    private var queue = DispatchGroup()
    private var addMemberError: AmityError?
    private var removeMemberError: AmityError?
    
    init(communityId: String) {
        membershipParticipation = AmityCommunityParticipation(client: AmityUIKitManagerInternal.shared.client, andCommunityId: communityId)
    }
    
    deinit {
        membershipParticipation = nil
    }
    
    func add(currentUsers: [AmityCommunityMembershipModel], newUsers users: [AmitySelectMemberModel], _ completion: @escaping (AmityError?, AmityCommunityAddMemberError?) -> Void) {
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
