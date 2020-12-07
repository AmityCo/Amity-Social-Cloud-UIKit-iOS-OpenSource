//
//  EkoCommunityProfileScreenViewModel.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 15/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoCommunityProfileScreenViewModel: EkoCommunityProfileScreenViewModelType {
    enum Route {
        case intial
        case post
        case settings
        case editProfile
        case member
    }
    
    enum CommunityStatus: Int {
        case notJoin
        case joinNotCreator
        case joinAndCreator
    }
    
    enum SettingsActionComplete {
        case intial
        case leave
        case close
    }
    
    // MARK: - Properties
    private let repository: EkoCommunityRepository
    private var communityInfoToken: EkoNotificationToken?
    let communityId: String
    
    init(communityId: String) {
        repository = EkoCommunityRepository(client: UpstraUIKitManagerInternal.shared.client)
        self.communityId = communityId
    }
    
    // MARK: DataSource
    var community: EkoBoxBinding<EkoCommunityModel?> = EkoBoxBinding(nil)
    var route: EkoBoxBinding<Route> = EkoBoxBinding(.intial)
    var parentObserveCommunityStatus: EkoBoxBinding<CommunityStatus> = EkoBoxBinding(.notJoin)
    var childCommunityStatus: EkoBoxBinding<CommunityStatus> = EkoBoxBinding(.notJoin)
    var childBottomCommunityIsCreator: EkoBoxBinding<Bool> = EkoBoxBinding(false)
    var settingsAction: EkoBoxBinding<SettingsActionComplete> = EkoBoxBinding(.intial)
    
    func currentCommunityStatus(tag: Int) -> CommunityStatus {
        return CommunityStatus(rawValue: tag) ?? .notJoin
    }
}

// MARK: Action
extension EkoCommunityProfileScreenViewModel {
    
    func route(to route: Route) {
        self.route.value = route
    }
    
    func getInfo() {
        communityInfoToken?.invalidate()
        communityInfoToken = repository.getCommunity(withId: communityId).observe { [weak self] (community, error) in
            guard let object = community.object else { return }
            let model = EkoCommunityModel(object: object)
            self?.community.value = model
            self?.childBottomCommunityIsCreator.value = model.isCreator
            self?.updateCommunityStatus(with: model)
        }
    }

    func join() {
        repository.joinCommunity(withCommunityId: communityId) { [weak self] (status, error) in
            guard let strongSelf = self else { return }
            if status {
                strongSelf.updateCommunityStatus(with: strongSelf.community.value)
            }
        }
    }
    
    func leaveCommunity() {
        repository.leaveCommunity(withCommunityId: communityId) { [weak self] (status, error) in
            if error != nil {
                return
            }
            
            if status {
                self?.settingsAction.value = .leave
            }
        }
    }
    
    func deleteCommunity() {
        repository.deleteCommunity(withId: communityId) { [weak self] (status, error) in
            if error != nil {
                return
            }
            
            if status {
                self?.settingsAction.value = .close
            }
        }
    }
    
    private func updateCommunityStatus(with community: EkoCommunityModel?) {
        guard let community = community else { return }
        if !community.isJoined {
            parentObserveCommunityStatus.value = .notJoin
            childCommunityStatus.value = .notJoin
        } else {
            if (community.isJoined && (!community.isCreator && EkoUserManager.shared.isModerator())) {
                parentObserveCommunityStatus.value = .joinNotCreator
                childCommunityStatus.value = .joinNotCreator
            } else if community.isJoined && (community.isCreator || EkoUserManager.shared.isModerator()) {
                parentObserveCommunityStatus.value = .joinAndCreator
                childCommunityStatus.value = .joinAndCreator
            } else {
                parentObserveCommunityStatus.value = .joinNotCreator
                childCommunityStatus.value = .joinNotCreator
            }
        }
    }
}
