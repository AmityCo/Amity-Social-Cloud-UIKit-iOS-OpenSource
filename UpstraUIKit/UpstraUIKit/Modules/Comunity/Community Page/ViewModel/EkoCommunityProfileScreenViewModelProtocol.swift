//
//  EkoCommunityProfileScreenViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 1/8/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
import EkoChat

enum EkoCommunityProfileRoute {
    case post
    case member
    case settings
    case editProfile
}

protocol EkoCommunityProfileScreenViewModelDelegate: class {
    func screenViewModelDidGetCommunity(with community: EkoCommunityModel)
    func screenViewModelDidJoinCommunitySuccess()
    func screenViewModelDidJoinCommunity(_ status: EkoCommunityProfileScreenViewModel.CommunityJoinStatus)
    func screenViewModelFailure()
    func screenViewModelRoute(_ viewModel: EkoCommunityProfileScreenViewModel, route: EkoCommunityProfileRoute)
}

protocol EkoCommunityProfileHeaderScreenViewModelDelegate: class {
    
}

protocol EkoCommunityProfileScreenViewModelDataSource {
    var getCommunityJoinStatus: EkoCommunityProfileScreenViewModel.CommunityJoinStatus { get }
    var community: EkoCommunityModel? { get }
    var communityId: String { get }
    var isModerator: Bool { get }
}

protocol EkoCommunityProfileScreenViewModelAction {
    
    func getCommunity()
    func getUserRole()
    func joinCommunity()
    func route(_ route: EkoCommunityProfileRoute)
}

protocol EkoCommunityProfileScreenViewModelType: EkoCommunityProfileScreenViewModelAction, EkoCommunityProfileScreenViewModelDataSource {
    var delegate: EkoCommunityProfileScreenViewModelDelegate? { get set }
    var headerDelegate: EkoCommunityProfileScreenViewModelDelegate? { get set }
    var action: EkoCommunityProfileScreenViewModelAction { get }
    var dataSource: EkoCommunityProfileScreenViewModelDataSource { get }
}

extension EkoCommunityProfileScreenViewModelType {
    var action: EkoCommunityProfileScreenViewModelAction { return self }
    var dataSource: EkoCommunityProfileScreenViewModelDataSource { return self }
}


