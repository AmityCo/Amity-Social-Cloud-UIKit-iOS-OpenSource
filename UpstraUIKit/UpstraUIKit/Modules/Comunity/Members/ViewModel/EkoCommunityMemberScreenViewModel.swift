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
    
    weak var delegate: EkoCommunityMemberScreenViewModelDelegate?
    
    private var flagger: EkoUserFlagger?
    private let membershipParticipation: EkoCommunityParticipation?
    private let communityRepository: EkoCommunityRepository?
    
    // MARK: - Controller
    private var memberController: EkoCommunityMemberController?
    private var communityController: EkoCommunityController?
    
    // MARK: - Properties
    private var members: [EkoCommunityMembershipModel] = []
    private var _community: EkoCommunityModel?
    
    init(communityId: String) {
        membershipParticipation = EkoCommunityParticipation(client: UpstraUIKitManagerInternal.shared.client, andCommunityId: communityId)
        memberController = EkoCommunityMemberController(membershipParticipation: membershipParticipation)
        communityRepository = EkoCommunityRepository(client: UpstraUIKitManagerInternal.shared.client)
        communityController = EkoCommunityController(repository: communityRepository, communityId: communityId)
    }

}

// MARK: - DataSource
extension EkoCommunityMemberScreenViewModel {    
    func numberOfMembers() -> Int {
        return members.count
    }
    
    func member(at indexPath: IndexPath) -> EkoCommunityMembershipModel {
        return members[indexPath.row]
    }
    
    func community() -> EkoCommunityModel? {
        return _community
    }
    
    func getReportUserStatus(at indexPath: IndexPath, completion: ((Bool) -> Void)?) {
        guard let user = member(at: indexPath).user else { return }
        flagger = EkoUserFlagger(client: UpstraUIKitManagerInternal.shared.client, user: user)
        flagger?.isFlagByMe {
            completion?($0)
        }
    }
    
}

// MARK: - Action
extension EkoCommunityMemberScreenViewModel {
    
    func getMember(viewType: EkoCommunityMemberViewType) {
        switch viewType {
        case .member:
            memberController?.getMember { [weak self] (result) in
                switch result {
                case .success(let members):
                    self?.members = members
                    self?.delegate?.screenViewModelDidGetMember()
                case .failure(let error):
                    break
                }
            }
        case .moderator:
            memberController?.getMember(roles: ["moderator"]) { [weak self] (result) in
                switch result {
                case .success(let members):
                    self?.members = members
                    self?.delegate?.screenViewModelDidGetMember()
                case .failure(let error):
                    break
                }
            }
        }
    }
    
    func getCommunity() {
        communityController?.getCommunity { [weak self] result in
            switch result {
            case .success(let community):
                self?._community = community
            case .failure(let error):
                break
            }
        }
    }
    
    func loadMore() {
        memberController?.loadMore { [weak self] success in
            if success {
                self?.delegate?.screenViewModelLoadingState(state: .loadmore)
            } else {
                self?.delegate?.screenViewModelLoadingState(state: .loaded)
            }
        }
    }
    
    func removeUser(at indexPath: IndexPath) {
        let userId = member(at: indexPath).userId
        memberController?.remove(userIds: [userId]) { [weak self] in
            self?.delegate?.screenViewModelDidRemoveUser(at: indexPath)
        }
    }
    
    func reportUser(at indexPath: IndexPath) {
        guard let user = member(at: indexPath).user else { return }
        flagger = EkoUserFlagger(client: UpstraUIKitManagerInternal.shared.client, user: user)
        flagger?.flag { (success, error) in
            if let error = error {
                EkoHUD.show(.error(message: error.localizedDescription))
            } else {
                EkoHUD.show(.success(message: EkoLocalizedStringSet.HUD.reportSent))
            }
        }
    }
    
    func unreportUser(at indexPath: IndexPath) {
        guard let user = member(at: indexPath).user else { return }
        flagger = EkoUserFlagger(client: UpstraUIKitManagerInternal.shared.client, user: user)
        flagger?.unflag { (success, error) in
            if let error = error {
                EkoHUD.show(.error(message: error.localizedDescription))
            } else {
                EkoHUD.show(.success(message: EkoLocalizedStringSet.HUD.unreportSent))
            }
        }
    }
    
}
