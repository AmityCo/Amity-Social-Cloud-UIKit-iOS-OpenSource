//
//  EkoCommunitySettingsScreenViewModel.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 1/8/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

final class EkoCommunitySettingsScreenViewModel: EkoCommunitySettingsScreenViewModelType {
    weak var delegate: EkoCommunitySettingsScreenViewModelDelegate?
    
    // MARK: - Controller
    private let communityInfoController: EkoCommunityInfoControllerProtocol
    private let communityLeaveController: EkoCommunityLeaveControllerProtocol
    private let communityDeleteController: EkoCommunityDeleteControllerProtocol
    
    // MARK: - Properties
    var communityId: String = ""
    var isCreator: Bool {
        return community?.isCreator ?? false
    }
    private var community: EkoCommunityModel?
    
    init(communityId: String) {
        self.communityId = communityId
        self.communityInfoController = EkoCommunityInfoController(communityId: communityId)
        self.communityLeaveController = EkoCommunityLeaveController(withCommunityId: communityId)
        self.communityDeleteController = EkoCommunityDeleteController(withCommunityId: communityId)
    }
}

// MARK: - DataSource
extension EkoCommunitySettingsScreenViewModel {
    
    func getCommunity() {
        communityInfoController.getCommunity { [weak self] (result) in
            switch result {
            case .success(let community):
                self?.community = community
                self?.delegate?.screenViewModelDidGetCommunitySuccess(community: community)
            case .failure:
                break
            }
        }
    }
    func leaveCommunity() {
        communityLeaveController.leave { [weak self] (error) in
            if let _ = error {
                self?.delegate?.screenViewModelFailure()
            } else {
                self?.delegate?.screenViewModelDidLeaveCommunitySuccess()
            }
        }
    }
    
    func deleteCommunity() {
        communityDeleteController.delete { [weak self] (error) in
            if let _ = error {
                self?.delegate?.screenViewModelFailure()
            } else {
                self?.delegate?.screenVieWModelDidDeleteCommunitySuccess()
            }
        }
    }
}

// MARK: - Action
extension EkoCommunitySettingsScreenViewModel {
    
}
