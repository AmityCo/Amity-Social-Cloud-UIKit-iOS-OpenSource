//
//  AmityChannelMemberScreenViewModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 15/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

final class AmityChannelMemberScreenViewModel: AmityChannelMemberScreenViewModelType {
    weak var delegate: AmityChannelMemberScreenViewModelDelegate?
    
    private var flagger: AmityUserFlagger?
    
    // MARK: - Repository
    private var userRepository: AmityUserRepository?
    
    // MARK: - Controller
    private let fetchMemberController: AmityChannelFetchMemberControllerProtocol
    private let removeMemberController: AmityChannelRemoveMemberControllerProtocol
    private let addMemberController: AmityChannelAddMemberControllerProtocol
    private let roleController: AmityChannelRoleControllerProtocol
    private var searchUserController: AmitySearchUserController?
    
    // MARK: - Properties
    private var members: [AmityChannelMembershipModel] = []
    private var searchedMember: [AmityChannelMembershipModel] = []
    
    var isSearch = false
    let channel: AmityChannelModel
    
    init(channel: AmityChannelModel,
         fetchMemberController: AmityChannelFetchMemberControllerProtocol,
         removeMemberController: AmityChannelRemoveMemberControllerProtocol,
         addMemberController: AmityChannelAddMemberControllerProtocol,
         roleController: AmityChannelRoleControllerProtocol) {
        self.channel = channel
        userRepository = AmityUserRepository(client: AmityUIKitManagerInternal.shared.client)
        self.fetchMemberController = fetchMemberController
        self.removeMemberController = removeMemberController
        self.addMemberController = addMemberController
        self.roleController = roleController
        self.searchUserController = AmitySearchUserController(repository: userRepository)
    }
    
}

// MARK: - DataSource
extension AmityChannelMemberScreenViewModel {

    func numberOfMembers() -> Int {
        return isSearch ? searchedMember.count : members.count
    }
    
    func member(at indexPath: IndexPath) -> AmityChannelMembershipModel {
        return isSearch ? searchedMember[indexPath.row]  : members[indexPath.row]
    }

    func getReportUserStatus(at indexPath: IndexPath, completion: ((Bool) -> Void)?) {
        guard let user = member(at: indexPath).user else { return }
        flagger = AmityUserFlagger(client: AmityUIKitManagerInternal.shared.client, userId: user.userId)
        flagger?.isFlaggedByMe {
            completion?($0)
        }
    }
    
    func prepareData() -> [AmitySelectMemberModel] {
        return members
            .map { AmitySelectMemberModel(object: $0) }
    }
    
    func getChannelEditUserPermission(_ completion: ((Bool) -> Void)?) {
        AmityUIKitManagerInternal.shared.client.hasPermission(.editChannel, forChannel: channel.channelId, completion: { hasPermission in
            completion?(hasPermission)
        })
    }
}
// MARK: - Action
extension  AmityChannelMemberScreenViewModel{
    
}
/// Get Member of channel
extension AmityChannelMemberScreenViewModel {
    func getMember(viewType: AmityChannelMemberViewType) {
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
            fetchMemberController.fetch(roles: [AmityChannelRole.moderator.rawValue, AmityChannelRole.channelModerator.rawValue]) { [weak self] (result) in
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
extension AmityChannelMemberScreenViewModel {
    func addUser(users: [AmitySelectMemberModel]) {
        addMemberController.add(currentUsers: members, newUsers: users, { [weak self] (amityError, controllerError) in
            guard let strongSelf = self else { return }
            if let error = amityError {
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
extension AmityChannelMemberScreenViewModel {
    func reportUser(at indexPath: IndexPath) {
        guard let user = member(at: indexPath).user else { return }
        flagger = AmityUserFlagger(client: AmityUIKitManagerInternal.shared.client, userId: user.userId)
        flagger?.flag { (success, error) in
            if let error = error {
                AmityHUD.show(.error(message: error.localizedDescription))
            } else {
                AmityHUD.show(.success(message: AmityLocalizedStringSet.HUD.reportSent.localizedString))
            }
        }
    }
    
    func unreportUser(at indexPath: IndexPath) {
        guard let user = member(at: indexPath).user else { return }
        flagger = AmityUserFlagger(client: AmityUIKitManagerInternal.shared.client, userId: user.userId)
        flagger?.unflag { (success, error) in
            if let error = error {
                AmityHUD.show(.error(message: error.localizedDescription))
            } else {
                AmityHUD.show(.success(message: AmityLocalizedStringSet.HUD.unreportSent.localizedString))
            }
        }
    }
    
    
}
/// Remove user
extension AmityChannelMemberScreenViewModel {
    func removeUser(at indexPath: IndexPath) {
        // remove user role and remove user from channel
        removeRole(at: indexPath)
        removeMemberController.remove(users: members, at: indexPath) { [weak self] (error) in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.delegate?.screenViewModel(strongSelf, failure: error)
            } else {
                strongSelf.delegate?.screenViewModelDidRemoveMemberSuccess()
            }
        }
    }
}

/// channel Role action
extension AmityChannelMemberScreenViewModel {
    func addRole(at indexPath: IndexPath) {
        let userId = member(at: indexPath).userId
        roleController.add(role: .channelModerator, userIds: [userId]) { [weak self] error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.delegate?.screenViewModel(strongSelf, failure: error)
            } else {
                strongSelf.delegate?.screenViewModelDidAddRoleSuccess()
            }
        }
    }
    
    func searchUser(with searchText: String) {
        isSearch = !searchText.isEmpty
        searchedMember = members.filter{
            $0.displayName.range(of: searchText, options: .caseInsensitive) != nil
        }
        delegate?.screenViewModelDidSearchUser()
    }
    
    func removeRole(at indexPath: IndexPath) {
        let user = member(at: indexPath)
        var role = AmityChannelRole.moderator
        let isCommunityModerator = user.channelRoles.contains { currentRole in
            currentRole == .channelModerator
        }

        if isCommunityModerator {
            role = .channelModerator
        }
        
        roleController.remove(role: role, userIds: [user.userId]) { [weak self] error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.delegate?.screenViewModel(strongSelf, failure: error)
            } else {
                strongSelf.delegate?.screenViewModelDidRemoveRoleSuccess()
            }
        }
    }
}
