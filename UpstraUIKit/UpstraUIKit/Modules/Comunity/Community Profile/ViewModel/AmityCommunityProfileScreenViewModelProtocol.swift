//
//  AmityCommunityProfileScreenViewModelProtocol.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 20/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

enum AmityCommunityProfileRoute {
    case post
    case member
    case settings
    case editProfile
    case pendingPosts
    case deeplinksPost(id: String)
}

protocol AmityCommunityProfileScreenViewModelDelegate: AnyObject {
    func screenViewModelDidGetCommunity(with community: AmityCommunityModel)
    func screenViewModelFailure()
    func screenViewModelRoute(_ viewModel: AmityCommunityProfileScreenViewModel, route: AmityCommunityProfileRoute)
    func screenViewModelDidShowAlertDialog()
    func screenViewModelRouteDeeplink()
}

protocol AmityCommunityProfileScreenViewModelDataSource {
    var communityId: String { get }
    var community: AmityCommunityModel? { get }
    var memberStatusCommunity: AmityMemberStatusCommunity { get }
    var postCount: Int { get }
    
    func shouldShowPendingPostBannerForMember(_ completion: ((Bool) -> Void)?)
    
    var fromDeeplinks: Bool { get set }
    var postId: String? { get set }
}

protocol AmityCommunityProfileScreenViewModelAction {
    func retriveCommunity()
    func getPendingPostCount(completion: ((Int) -> Void)?)
    func joinCommunity()
    
    func route(_ route: AmityCommunityProfileRoute)
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
