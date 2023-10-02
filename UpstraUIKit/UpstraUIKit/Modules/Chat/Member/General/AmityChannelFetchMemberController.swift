//
//  AmityChannelFetchMemberController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 22/12/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityChannelFetchMemberControllerProtocol {
    func fetch(roles: [String], _ completion: @escaping (Result<[AmityChannelMembershipModel], Error>) -> Void)
    func loadMore(_ completion: (Bool) -> Void)
}

final class AmityChannelFetchMemberController: AmityChannelFetchMemberControllerProtocol {
    
    private var membershipParticipation: AmityChannelParticipation?
    private var memberCollection: AmityCollection<AmityChannelMember>?
    private var memberToken: AmityNotificationToken?
    
    init(channelId: String) {
        membershipParticipation = AmityChannelParticipation(client: AmityUIKitManagerInternal.shared.client, andChannel: channelId)
    }
    
    func fetch(roles: [String], _ completion: @escaping (Result<[AmityChannelMembershipModel], Error>) -> Void) {
        memberCollection = membershipParticipation?.getMembers(filter: .all, sortBy: .lastCreated, roles: roles)
        memberToken?.invalidate()
        memberToken = memberCollection?.observe { (collection, change, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                if collection.dataStatus == .fresh {
                    var members: [AmityChannelMembershipModel] = []
                    for index in 0..<collection.count() {
                        guard let member = collection.object(at: index) else { continue }
                        members.append(AmityChannelMembershipModel(member: member))
                    }
                    completion(.success(members))
                }
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
