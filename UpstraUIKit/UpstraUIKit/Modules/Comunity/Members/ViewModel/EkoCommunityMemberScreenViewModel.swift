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
    
    // MARK: - Controller
    private var communityController: EkoCommunityInfoController?
    private var fetchMemberController: EkoCommunityFetchMemberController?
    private var removeMemberController: EkoCommunityRemoveMemberController?
    private var userModeratorController: EkoCommunityUserModeratorController?
    private var addMemberController: EkoCommunityAddMemberController?
    private let roleController: EkoCommunityRoleControllerProtocol
    // MARK: - Properties
    private var members: [EkoCommunityMembershipModel] = []
    private var community: EkoCommunityModel?
    
    init(membershipParticipation: EkoCommunityParticipation?,
         userModeratorController: EkoCommunityUserModeratorController?,
         communityController: EkoCommunityInfoController?,
         communityId: String) {
        self.communityController = communityController
        self.userModeratorController = userModeratorController
        fetchMemberController = EkoCommunityFetchMemberController(communityId: communityId)
        removeMemberController = EkoCommunityRemoveMemberController(communityId: communityId)
        addMemberController = EkoCommunityAddMemberController(communityId: communityId)
        roleController = EkoCommunityRoleController(communityId: communityId)
    }
    
    var isModerator: Bool = false
        
}

// MARK: - DataSource
extension EkoCommunityMemberScreenViewModel {    
    func numberOfMembers() -> Int {
        return members.count
    }
    
    func member(at indexPath: IndexPath) -> EkoCommunityMembershipModel {
        return members[indexPath.row]
    }

    func getReportUserStatus(at indexPath: IndexPath, completion: ((Bool) -> Void)?) {
        guard let user = member(at: indexPath).user else { return }
        flagger = EkoUserFlagger(client: UpstraUIKitManagerInternal.shared.client, user: user)
        flagger?.isFlagByMe {
            completion?($0)
        }
    }
    
    func prepareData() -> [EkoSelectMemberModel] {
        
        var storeUsers: [EkoSelectMemberModel] = []
        for item in members {
            if !item.isCurrentUser {
                storeUsers.append(EkoSelectMemberModel(object: item))
            }
        }
        return storeUsers
    }
    
    func isJoined() -> Bool {
        return community?.isJoined ?? false
    }
}

// MARK: - Action

/// Get community info
extension EkoCommunityMemberScreenViewModel {
    func getCommunity() {
        communityController?.getCommunity { (result) in
            switch result {
            case .success(let community):
                self.community = community
            case .failure:
                break
            }
        }
    }
}

extension EkoCommunityMemberScreenViewModel {
    func getUserIsModerator() {
        isModerator = userModeratorController?.isModerator ?? false
    }
}

/// Get Member of community
extension EkoCommunityMemberScreenViewModel {
    func getMember(viewType: EkoCommunityMemberViewType) {
        switch viewType {
        case .member:
            fetchMemberController?.fetch { [weak self] (result) in
                switch result {
                case .success(let members):
                    self?.members = members
                    self?.delegate?.screenViewModelDidGetMember()
                case .failure(let error):
                    break
                }
            }
        case .moderator:
            fetchMemberController?.fetch(roles: ["moderator"]) { [weak self] (result) in
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

    func loadMore() {
        fetchMemberController?.loadMore { [weak self] success in
            if success {
                self?.delegate?.screenViewModelLoadingState(state: .loadmore)
            } else {
                self?.delegate?.screenViewModelLoadingState(state: .loaded)
            }
        }
    }
}

/// Add user
extension EkoCommunityMemberScreenViewModel {
    func addUser(users: [EkoSelectMemberModel]) {
        let userIds = users.map { $0.userId }
        addMemberController?.add(withUserIds: userIds, { [weak self] (result) in
            switch result {
            case .success(let success):
                self?.delegate?.screenViewModelDidAddMember(success: success)
            case .failure(let error):
                Log.add(error)
                self?.delegate?.screenViewModelDidAddMember(success: false)
            }
        })
    }
}

// MARK: Options

/// Report/Unreport user
extension EkoCommunityMemberScreenViewModel {
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
/// Remove user
extension EkoCommunityMemberScreenViewModel {
    func removeUser(at indexPath: IndexPath) {
        let userId = member(at: indexPath).userId
        removeMemberController?.remove(userIds: [userId]) { [weak self] in
            self?.members.remove(at: indexPath.row)
            self?.delegate?.screenViewModelDidRemoveUser(at: indexPath)
        }
    }
}

/// Community Role action
extension EkoCommunityMemberScreenViewModel {
    func addRole(at indexPath: IndexPath) {
        let userId = member(at: indexPath).userId
        roleController.add(role: .moderator, userIds: [userId]) { [weak self] error in
            if let error = error {
                Log.add(error)
                self?.delegate?.screenViewModelFailure()
            } else {
                
            }
        }
    }
    
    func removeRole(at indexPath: IndexPath) {
        let userId = member(at: indexPath).userId
        roleController.remove(role: .moderator, userIds: [userId]) { [weak self] error in
            if let error = error {
                Log.add(error)
                self?.delegate?.screenViewModelFailure()
            } else {
                
            }
        }
    }
}
