//
//  AmityCommunityProfileScreenViewModelProtocol.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 1/8/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

enum AmityCommunityProfileRoute {
    case post
    case member
    case settings
    case editProfile
}

protocol AmityCommunityProfileScreenViewModelDelegate: class {
    func screenViewModelDidGetCommunity(with community: AmityCommunityModel)
    func screenViewModelDidJoinCommunitySuccess()
    func screenViewModelDidJoinCommunity(_ status: AmityCommunityProfileScreenViewModel.CommunityJoinStatus)
    func screenViewModelFailure()
    func screenViewModelRoute(_ viewModel: AmityCommunityProfileScreenViewModel, route: AmityCommunityProfileRoute)
    func screenViewModelShowCommunitySettingsModal(_ viewModel: AmityCommunityProfileScreenViewModel, withModel model: AmityDefaultModalModel)
}

protocol AmityCommunityProfileHeaderScreenViewModelDelegate: class {
    
}

protocol AmityCommunityProfileScreenViewModelDataSource {
    var getCommunityJoinStatus: AmityCommunityProfileScreenViewModel.CommunityJoinStatus { get }
    var community: AmityCommunityModel? { get }
    var communityId: String { get }
    var isModerator: Bool { get }
}

protocol AmityCommunityProfileScreenViewModelAction {
    
    func getCommunity()
    func getUserRole()
    func joinCommunity()
    func route(_ route: AmityCommunityProfileRoute)
    
    func showCommunitySettingsModal()
}

protocol AmityCommunityProfileScreenViewModelType: AmityCommunityProfileScreenViewModelAction, AmityCommunityProfileScreenViewModelDataSource {
    var delegate: AmityCommunityProfileScreenViewModelDelegate? { get set }
    var action: AmityCommunityProfileScreenViewModelAction { get }
    var dataSource: AmityCommunityProfileScreenViewModelDataSource { get }
}

extension AmityCommunityProfileScreenViewModelType {
    var action: AmityCommunityProfileScreenViewModelAction { return self }
    var dataSource: AmityCommunityProfileScreenViewModelDataSource { return self }
}


