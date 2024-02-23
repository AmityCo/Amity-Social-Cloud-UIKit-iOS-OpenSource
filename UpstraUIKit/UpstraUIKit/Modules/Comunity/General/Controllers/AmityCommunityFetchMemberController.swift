//
//  AmityCommunityFetchMemberController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 22/12/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityCommunityFetchMemberControllerProtocol {
    func fetch(roles: [String], _ completion: @escaping (Result<[AmityCommunityMembershipModel], Error>) -> Void)
    func loadMore(_ completion: (Bool) -> Void)
}

final class AmityCommunityFetchMemberController: AmityCommunityFetchMemberControllerProtocol {
    
    private var membershipParticipation: AmityCommunityParticipation?
    private var memberCollection: AmityCollection<AmityCommunityMember>?
    private var memberToken: AmityNotificationToken?
    
    init(communityId: String) {
        membershipParticipation = AmityCommunityParticipation(client: AmityUIKitManagerInternal.shared.client, andCommunityId: communityId)
    }
    
    func fetch(roles: [String], _ completion: @escaping (Result<[AmityCommunityMembershipModel], Error>) -> Void) {
        memberCollection = membershipParticipation?.getMembers(membershipOptions: [.member], roles: roles, sortBy: .lastCreated)
        memberToken = memberCollection?.observe { (collection, change, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                var members: [AmityCommunityMembershipModel] = []
                for index in 0..<collection.count() {
                    guard let member = collection.object(at: index) else { continue }
                    members.append(AmityCommunityMembershipModel(member: member))
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
