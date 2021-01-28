//
//  EkoCommunityFetchMemberController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 22/12/2563 BE.
//  Copyright © 2563 BE Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoCommunityFetchMemberControllerProtocol {
    func fetch(roles: [String], _ completion: @escaping (Result<[EkoCommunityMembershipModel], Error>) -> Void)
    func loadMore(_ completion: (Bool) -> Void)
}

final class EkoCommunityFetchMemberController: EkoCommunityFetchMemberControllerProtocol {
    
    private var membershipParticipation: EkoCommunityParticipation?
    private var memberCollection: EkoCollection<EkoCommunityMembership>?
    private var memberToken: EkoNotificationToken?
    
    init(communityId: String) {
        membershipParticipation = EkoCommunityParticipation(client: UpstraUIKitManagerInternal.shared.client, andCommunityId: communityId)
    }
    
    func fetch(roles: [String], _ completion: @escaping (Result<[EkoCommunityMembershipModel], Error>) -> Void) {
        memberCollection = membershipParticipation?.getMemberships(.all, roles: roles, sortBy: .lastCreated)
        memberToken = memberCollection?.observe { (collection, change, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                var members: [EkoCommunityMembershipModel] = []
                for index in 0..<collection.count() {
                    guard let member = collection.object(at: index) else { continue }
                    var model = EkoCommunityMembershipModel(member: member)
                    if let roles = model.roles as? [String], roles.contains(EkoCommunityRole.moderator.rawValue) {
                        model.isModerator = true
                    }
                    members.append(model)
                }
                completion(.success(members))
            }
        }
    }
    
    func loadMore(_ completion: (Bool) -> Void) {
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
