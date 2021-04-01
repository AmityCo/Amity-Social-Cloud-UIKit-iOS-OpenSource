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
    private let fetchMemberController: EkoCommunityFetchMemberControllerProtocol
    private let removeMemberController: EkoCommunityRemoveMemberControllerProtocol
    private let addMemberController: EkoCommunityAddMemberControllerProtocol
    private let roleController: EkoCommunityRoleControllerProtocol
    
    // MARK: - Properties
    private var members: [EkoCommunityMembershipModel] = []
    let community: EkoCommunityModel
    
    init(community: EkoCommunityModel,
         fetchMemberController: EkoCommunityFetchMemberControllerProtocol,
         removeMemberController: EkoCommunityRemoveMemberControllerProtocol,
         addMemberController: EkoCommunityAddMemberControllerProtocol,
         roleController: EkoCommunityRoleControllerProtocol) {
        self.community = community
        self.fetchMemberController = fetchMemberController
        self.removeMemberController = removeMemberController
        self.addMemberController = addMemberController
        self.roleController = roleController
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

    func getReportUserStatus(at indexPath: IndexPath, completion: ((Bool) -> Void)?) {
        guard let user = member(at: indexPath).user else { return }
        flagger = EkoUserFlagger(client: UpstraUIKitManagerInternal.shared.client, user: user)
        flagger?.isFlagByMe {
            completion?($0)
        }
    }
    
    func prepareData() -> [EkoSelectMemberModel] {
        return members
            .filter { !$0.isCurrentUser }
            .map { EkoSelectMemberModel(object: $0) }
    }
}
// MARK: - Action
extension  EkoCommunityMemberScreenViewModel{
    func getCommunityEditUserPermission(_ completion: ((Bool) -> Void)?) {
        UpstraUIKitManagerInternal.shared.client.hasPermission(.editCommunityUser, forCommunity: community.communityId) { [weak self] (hasPermission) in
            guard let strongSelf = self else { return }
            if strongSelf.community.isCreator {
                completion?(true)
            } else {
                completion?(hasPermission)
            }
        }
    }
}
/// Get Member of community
extension EkoCommunityMemberScreenViewModel {
    func getMember(viewType: EkoCommunityMemberViewType) {
        switch viewType {
        case .member:
            fetchMemberController.fetch(roles: []) { [weak self] (result) in
                switch result {
                case .success(let members):
                    self?.members = members
                    self?.delegate?.screenViewModelDidGetMember()
                case .failure:
                    break
                }
            }
        case .moderator:
            fetchMemberController.fetch(roles: [EkoCommunityRole.moderator.rawValue]) { [weak self] (result) in
                switch result {
                case .success(let members):
                    self?.members = members
                    self?.delegate?.screenViewModelDidGetMember()
                case .failure:
                    break
                }
            }
        }
    }

    func loadMore() {
        fetchMemberController.loadMore { [weak self] success in
            guard let strongSelf = self else { return }
            if success {
                strongSelf.delegate?.screenViewModel(strongSelf, loadingState: .loading)
            } else {
                strongSelf.delegate?.screenViewModel(strongSelf, loadingState: .loaded)
            }
        }
    }
}

/// Add user
extension EkoCommunityMemberScreenViewModel {
    func addUser(users: [EkoSelectMemberModel]) {
        addMemberController.add(currentUsers: members, newUsers: users, { [weak self] (ekoError, controllerError) in
            guard let strongSelf = self else { return }
            if let error = ekoError {
                strongSelf.delegate?.screenViewModel(strongSelf, failure: error)
            } else if let controllerError = controllerError {
                switch controllerError {
                case .addMemberFailure(let error):
                    if let error = error {
                        strongSelf.delegate?.screenViewModel(strongSelf, failure: error)
                    } else {
                        strongSelf.delegate?.screenViewModelDidAddMemberSuccess()
                    }
                case .removeMemberFailure(let error):
                    if let error = error {
                        strongSelf.delegate?.screenViewModel(strongSelf, failure: error)
                    } else {
                        strongSelf.delegate?.screenViewModelDidAddMemberSuccess()
                    }
                }
            } else {
                self?.delegate?.screenViewModelDidAddMemberSuccess()
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
                EkoHUD.show(.success(message: EkoLocalizedStringSet.HUD.reportSent.localizedString))
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
                EkoHUD.show(.success(message: EkoLocalizedStringSet.HUD.unreportSent.localizedString))
            }
        }
    }
    
    
}
/// Remove user
extension EkoCommunityMemberScreenViewModel {
    func removeUser(at indexPath: IndexPath) {
        // remove user role and remove user from community
        removeRole(at: indexPath)
        removeMemberController.remove(users: members, at: indexPath) { [weak self] (error) in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.delegate?.screenViewModel(strongSelf, failure: error)
            } else {
                strongSelf.delegate?.screenViewModelDidRemoveRoleSuccess()
            }
        }
    }
}

/// Community Role action
extension EkoCommunityMemberScreenViewModel {
    func addRole(at indexPath: IndexPath) {
        let userId = member(at: indexPath).userId
        roleController.add(role: .moderator, userIds: [userId]) { [weak self] error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.delegate?.screenViewModel(strongSelf, failure: error)
            } else {
                strongSelf.delegate?.screenViewModelDidAddRoleSuccess()
            }
        }
    }
    
    func removeRole(at indexPath: IndexPath) {
        let userId = member(at: indexPath).userId
        roleController.remove(role: .moderator, userIds: [userId]) { [weak self] error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.delegate?.screenViewModel(strongSelf, failure: error)
            } else {
                strongSelf.delegate?.screenViewModelDidRemoveRoleSuccess()
            }
        }
    }
}
