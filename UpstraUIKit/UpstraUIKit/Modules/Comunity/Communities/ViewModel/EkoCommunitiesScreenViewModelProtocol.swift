//
//  EkoCommunitiesScreenViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 24/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoCommunitiesScreenViewModelAction {
    func route(to route: EkoCommunitiesScreenViewModel.Route)
    func search(with text: String?)
    func loadMore()
    func reset()
}

protocol EkoCommunitiesScreenViewModelDataSource {
    var searchCommunities: EkoBoxBinding<[EkoCommunityModel]> { get set }
    var route: EkoBoxBinding<EkoCommunitiesScreenViewModel.Route> { get set }
    var numberOfItems: EkoBoxBinding<Int> { get }
    var loading: EkoBoxBinding<EkoLoadingState> { get set }
    func community(at indexPath: IndexPath) -> EkoCommunityModel
    func reset()
}

protocol EkoCommunitiesScreenViewModelType: EkoCommunitiesScreenViewModelAction, EkoCommunitiesScreenViewModelDataSource {
    var action: EkoCommunitiesScreenViewModelAction { get }
    var dataSource: EkoCommunitiesScreenViewModelDataSource { get }
}

extension EkoCommunitiesScreenViewModelType {
    var action: EkoCommunitiesScreenViewModelAction { return self }
    var dataSource: EkoCommunitiesScreenViewModelDataSource { return self }
}
