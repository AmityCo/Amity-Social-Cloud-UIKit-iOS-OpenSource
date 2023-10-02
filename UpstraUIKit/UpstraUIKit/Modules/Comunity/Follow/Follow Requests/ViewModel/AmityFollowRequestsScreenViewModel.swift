//
//  AmityFollowRequestsScreenViewModel.swift
//  AmityUIKit
//
//  Created by Hamlet on 17.05.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

final class AmityFollowRequestsScreenViewModel: AmityFollowRequestsScreenViewModelType {
    
    weak var delegate: AmityFollowRequestsScreenViewModelDelegate?
    
    // MARK: - Properties
    let userId: String
    private let userRepository: AmityUserRepository
    private let followManager: AmityUserFollowManager
    private var followToken: AmityNotificationToken?
    private var followRequests: [AmityFollowRelationship] = []
    private var followRequestCollection: AmityCollection<AmityFollowRelationship>?
    
    // MARK: - Initializer
    init(userId: String) {
        userRepository = AmityUserRepository(client: AmityUIKitManagerInternal.shared.client)
        followManager = userRepository.followManager
        self.userId = userId
    }
}

// MARK: - DataSource
extension AmityFollowRequestsScreenViewModel {
    func numberOfRequests() -> Int {
        return followRequests.count
    }
    
    func item(at indexPath: IndexPath) -> AmityFollowRelationship {
        return followRequests[indexPath.row]
    }
}

// MARK: - Action
extension AmityFollowRequestsScreenViewModel {
    func getFollowRequests() {
        followToken?.invalidate()
        followRequestCollection = followManager.getMyFollowerList(with: .pending)
        followToken = followRequestCollection?.observe { [weak self] collection, _, error in
            self?.prepareDataSource(collection: collection, error: error)
        }
    }
    
    func acceptRequest(at indexPath: IndexPath) {
        let request = self.item(at: indexPath)
        followManager.acceptUserRequest(withUserId: request.sourceUserId) { [weak self] success, response, error in
            guard let strongSelf = self, indexPath.row < strongSelf.followRequests.count else { return }
            
            if success {
                strongSelf.removeRequest(at: indexPath)
                strongSelf.delegate?.screenViewModel(strongSelf, didAcceptRequestAt: indexPath)
            } else {
                strongSelf.delegate?.screenViewModel(strongSelf, didFailToAcceptRequestAt: indexPath)
            }
        }
    }
    
    func declineRequest(at indexPath: IndexPath) {
        let request = self.item(at: indexPath)
        followManager.declineUserRequest(withUserId: request.sourceUserId) { [weak self] success, response, error in
            guard let strongSelf = self, indexPath.row < strongSelf.followRequests.count else { return }
            
            if success {
                strongSelf.removeRequest(at: indexPath)
                strongSelf.delegate?.screenViewModel(strongSelf, didDeclineRequestAt: indexPath)
            } else {
                strongSelf.delegate?.screenViewModel(strongSelf, didFailToDeclineRequestAt: indexPath)
            }
        }
    }
    
    func removeRequest(at indexPath: IndexPath) {
        if indexPath.row < followRequests.count {
            followRequests.remove(at: indexPath.row)
            delegate?.screenViewModel(self, didRemoveRequestAt: indexPath)
        }
    }
    
    func reload() {
        getFollowRequests()
    }
}

private extension AmityFollowRequestsScreenViewModel {
    func prepareDataSource(collection: AmityCollection<AmityFollowRelationship>, error: Error?) {
        if let error = error {
            delegate?.screenViewModel(self, failure: AmityError(error: error) ?? .unknown)
            followToken?.invalidate()
            return
        }
        
        switch collection.dataStatus {
        case .fresh:
            var newRequests: [AmityFollowRelationship] = []
            for i in 0..<collection.count() {
                guard let follow = collection.object(at: i) else { continue }
                newRequests.append(follow)
            }
            
            followRequests = newRequests
            delegate?.screenViewModelDidGetRequests()
            followToken?.invalidate()
        default: break
        }
    }
}
