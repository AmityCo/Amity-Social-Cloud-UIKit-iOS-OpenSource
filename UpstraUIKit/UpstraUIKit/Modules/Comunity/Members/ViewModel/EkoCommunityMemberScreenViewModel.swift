//
//  EkoCommunityMemberScreenViewModel.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 15/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoCommunityMemberScreenViewModel: EkoCommunityMemberScreenViewModelType {
    
    enum CellAction {
        case option(indexPath: IndexPath)
    }
    
    private let membershipParticipation: EkoCommunityParticipation?
    private let communityId: String
    private var memberCollection: EkoCollection<EkoCommunityMembership>?
    private var memberToken: EkoNotificationToken?
    
    init(communityId: String) {
        self.communityId = communityId
        membershipParticipation = EkoCommunityParticipation(client: UpstraUIKitManager.shared.client, andCommunityId: communityId)
    }
    
    // MARK: - DataSource
    var membership: EkoBoxBinding<EkoCollection<EkoCommunityMembership>?> = EkoBoxBinding(nil)
    var cellAction: EkoBoxBinding<CellAction?> = EkoBoxBinding(nil)
    var loading: EkoBoxBinding<EkoLoadingState> = EkoBoxBinding(.initial)
    
    func numberOfMembers() -> Int {
        return Int(membership.value?.count() ?? 0)
    }
    
    func item(at indexPath: IndexPath) -> EkoCommunityMembership? {
        return membership.value?.object(at: UInt(indexPath.row)) ?? nil
    }
}


// MARK: - Action
extension EkoCommunityMemberScreenViewModel {
    func getMember() {
        memberCollection = membershipParticipation?.getMemberships(.all, sortBy: .lastCreated)
        memberToken?.invalidate()
        memberToken = memberCollection?.observe { [weak self] (collection, change, error) in
            self?.membership.value = collection
        }
    }
    
    func selectedItem(action: CellAction) {
        cellAction.value = action
    }
    
    func loadMore() {
        guard let collection = memberCollection else { return }
        
        switch collection.loadingStatus {
        case .loaded:
            if collection.hasNext {
                collection.nextPage()
                loading.value = .loadmore
            }
        default:
            break
        }
    }
}
