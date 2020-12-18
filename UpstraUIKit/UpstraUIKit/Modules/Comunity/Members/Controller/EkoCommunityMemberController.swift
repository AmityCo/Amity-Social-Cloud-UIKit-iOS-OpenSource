//
//  EkoCommunityMemberController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 15/12/2563 BE.
//  Copyright © 2563 BE Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoCommunityMemberController {
    
    weak var membershipParticipation: EkoCommunityParticipation?
    private var memberCollection: EkoCollection<EkoCommunityMembership>?
    private var memberToken: EkoNotificationToken?
    
    private var members: [EkoCommunityMembershipModel] = []
    
    init(membershipParticipation: EkoCommunityParticipation?) {
        self.membershipParticipation = membershipParticipation
    }
    
    func getMember(roles: [String] = [], completion: @escaping (Result<[EkoCommunityMembershipModel], Error>) -> Void) {
        memberCollection = membershipParticipation?.getMemberships(.all, roles: roles, sortBy: .lastCreated)
        memberToken?.invalidate()
        memberToken = memberCollection?.observe { [weak self] (collection, change, error) in
            if collection.dataStatus == .fresh {
                if let error = error {
                    completion(.failure(error))
                } else {
                    guard let strongSelf = self else { return }
                    for index in 0..<collection.count() {
                        guard let member = collection.object(at: index) else { continue }
                        var model = EkoCommunityMembershipModel(member: member)

                        let index = strongSelf.members.firstIndex(where: { $0.userId == member.userId })
                        if let index = index {
                            strongSelf.members[index] = model
                        } else {
                            strongSelf.members.append(model)
                        }
                        
                        for case let role as String in model.roles {
                            if role == "moderator" {
                                model.isModerator = true
                            }
                        }
                    }
                    
                    completion(.success(strongSelf.members))
                    self?.memberToken?.invalidate()
                }
            }
        }
    }
    
    func remove(userIds: [String], completion: @escaping () -> Void) {
        membershipParticipation?.removeUsers(userIds, completion: { (status, error) in
            guard status, error == nil else { return }
            completion()
        })
    }
    
    func loadMore(completion: (Bool) -> Void) {
        guard let collection = memberCollection else {
            completion(true)
            return
        }
        switch collection.loadingStatus {
        case .loaded:
            if collection.hasNext {
                collection.nextPage()
                completion(true)
            }
        default:
            completion(false)
        }
    }
}
