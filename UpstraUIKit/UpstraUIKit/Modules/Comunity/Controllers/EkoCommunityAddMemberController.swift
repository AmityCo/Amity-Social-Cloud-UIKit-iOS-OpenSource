//
//  EkoCommunityAddMemberController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 22/12/2563 BE.
//  Copyright © 2563 BE Upstra. All rights reserved.
//

import UIKit
import EkoChat

enum EkoCommunityAddMemberError {
    case addMemberFailure(EkoError?)
    case removeMemberFailure(EkoError?)
}

protocol EkoCommunityAddMemberControllerProtocol {
    func add(currentUsers: [EkoCommunityMembershipModel], newUsers users: [EkoSelectMemberModel], _ completion: @escaping (EkoError?, EkoCommunityAddMemberError?) -> Void)
}

final class EkoCommunityAddMemberController: EkoCommunityAddMemberControllerProtocol {
    
    private var membershipParticipation: EkoCommunityParticipation?
    
    private var queue = DispatchGroup()
    private var addMemberError: EkoError?
    private var removeMemberError: EkoError?
    
    init(communityId: String) {
        membershipParticipation = EkoCommunityParticipation(client: UpstraUIKitManagerInternal.shared.client, andCommunityId: communityId)
    }
    
    deinit {
        membershipParticipation = nil
    }
    
    func add(currentUsers: [EkoCommunityMembershipModel], newUsers users: [EkoSelectMemberModel], _ completion: @escaping (EkoError?, EkoCommunityAddMemberError?) -> Void) {
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
            membershipParticipation?.addUsers(userIds, completion: { [weak self] (success, error) in
                if success {
                    self?.addMemberError = nil
                } else {
                    self?.removeMemberError = EkoError(error: error) ?? .unknown
                }
                self?.queue.leave()
            })
        }
    }
    
    private func removeUsers(userIds: [String]) {
        if !userIds.isEmpty {
            queue.enter()
            membershipParticipation?.removeUsers(userIds, completion: { [weak self] (success, error) in
                if success {
                    self?.removeMemberError = nil
                } else {
                    self?.removeMemberError = EkoError(error: error) ?? .unknown
                }
                self?.queue.leave()
            })
        }
    }
}
