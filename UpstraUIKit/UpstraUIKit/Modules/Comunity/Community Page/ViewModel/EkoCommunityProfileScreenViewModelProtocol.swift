//
//  EkoCommunityProfileScreenViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 15/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoCommunityProfileScreenViewModelDataSource {
    var communityId: String { get }
    var community: EkoBoxBinding<EkoCommunityModel?> { get set }
    var route: EkoBoxBinding<EkoCommunityProfileScreenViewModel.Route> { get set }
    var childCommunityStatus: EkoBoxBinding<EkoCommunityProfileScreenViewModel.CommunityStatus> { get set }
    var childBottomCommunityIsCreator: EkoBoxBinding<Bool> { get set }
    var parentObserveCommunityStatus: EkoBoxBinding<EkoCommunityProfileScreenViewModel.CommunityStatus> { get set }
    var settingsAction: EkoBoxBinding<EkoCommunityProfileScreenViewModel.SettingsActionComplete> { get set }
    func currentCommunityStatus(tag: Int) -> EkoCommunityProfileScreenViewModel.CommunityStatus
}

protocol EkoCommunityProfileScreenViewModelAction {
    func getInfo()
    func route(to route: EkoCommunityProfileScreenViewModel.Route)
    func join()
    func leaveCommunity()
    func deleteCommunity()
}

protocol EkoCommunityProfileScreenViewModelType: EkoCommunityProfileScreenViewModelAction, EkoCommunityProfileScreenViewModelDataSource {
    var action: EkoCommunityProfileScreenViewModelAction { get }
    var dataSource: EkoCommunityProfileScreenViewModelDataSource { get }
}

extension EkoCommunityProfileScreenViewModelType {
    var action: EkoCommunityProfileScreenViewModelAction { return self }
    var dataSource: EkoCommunityProfileScreenViewModelDataSource { return self }
}

