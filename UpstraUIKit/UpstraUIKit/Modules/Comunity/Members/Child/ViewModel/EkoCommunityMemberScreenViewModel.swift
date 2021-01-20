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
    private var removeMemberController: EkoCommunityRemoveMemberControllerProtocol?
    private var userModeratorController: EkoCommunityUserRolesController?
    private var addMemberController: EkoCommunityAddMemberControllerProtocol?
    private let roleController: EkoCommunityRoleControllerProtocol
    // MARK: - Properties
    private var members: [EkoCommunityMembershipModel] = []
    private var community: EkoCommunityModel?
    
    init(communityId: String) {
        userModeratorController = EkoCommunityUserRolesController(communityId: communityId)
        communityController = EkoCommunityInfoController(communityId: communityId)
        fetchMemberController = EkoCommunityFetchMemberController(communityId: communityId)
        removeMemberController = EkoCommunityRemoveMemberController(communityId: communityId)
        addMemberController = EkoCommunityAddMemberController(communityId: communityId)
        roleController = EkoCommunityRoleController(communityId: communityId)
    }
    
    var isModerator: Bool = false
    var isJoined: Bool {
        return community?.isJoined ?? false
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
        var storeUsers: [EkoSelectMemberModel] = []
        for item in members {
            if !item.isCurrentUser {
                storeUsers.append(EkoSelectMemberModel(object: item))
            }
        }
        return storeUsers
    }
}

// MARK: - Action

/// Get community info
extension EkoCommunityMemberScreenViewModel {
    func getCommunity() {
        communityController?.getCommunity { [weak self] (result) in
            switch result {
            case .success(let community):
                self?.community = community
                self?.delegate?.screenViewModelDidGetComminityInfo()
            case .failure:
                break
            }
        }
    }
}

extension EkoCommunityMemberScreenViewModel {
    func getUserRoles() {
        if let _isModerator = userModeratorController?.getUserRoles(withUserId: UpstraUIKitManagerInternal.shared.currentUserId, role: .moderator) {
            isModerator = _isModerator
        }
        
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
            fetchMemberController?.fetch(roles: [EkoCommunityRole.moderator.rawValue]) { [weak self] (result) in
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
        addMemberController?.add(currentUsers: members, newUsers: users, { [weak self] (ekoError, controllerError) in
            if let error = ekoError {
                self?.delegate?.screenViewModelFailure(error: error)
            } else if let controllerError = controllerError {
                switch controllerError {
                case .addMemberFailure(let error):
                    if let error = error {
                        self?.delegate?.screenViewModelFailure(error: error)
                    } else {
                        self?.delegate?.screenViewModelDidAddMemberSuccess()
                    }
                case .removeMemberFailure(let error):
                    if let error = error {
                        self?.delegate?.screenViewModelFailure(error: error)
                    } else {
                        self?.delegate?.screenViewModelDidAddMemberSuccess()
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
        removeMemberController?.remove(users: members, at: indexPath, { (error) in
            if let error = error {
                self.delegate?.screenViewModelFailure(error: error)
            } else {
                self.delegate?.screenViewModelDidRemoveRoleSuccess()
            }
        })
    }
}

/// Community Role action
extension EkoCommunityMemberScreenViewModel {
    func addRole(at indexPath: IndexPath) {
        let userId = member(at: indexPath).userId
        roleController.add(role: .moderator, userIds: [userId]) { [weak self] error in
            if let error = error {
                self?.delegate?.screenViewModelFailure(error: error)
            } else {
                self?.delegate?.screenViewModelDidAddRoleSuccess()
            }
        }
    }
    
    func removeRole(at indexPath: IndexPath) {
        let userId = member(at: indexPath).userId
        roleController.remove(role: .moderator, userIds: [userId]) { [weak self] error in
            if let error = error {
                self?.delegate?.screenViewModelFailure(error: error)
            } else {
                self?.delegate?.screenViewModelDidRemoveRoleSuccess()
            }
        }
    }
}
