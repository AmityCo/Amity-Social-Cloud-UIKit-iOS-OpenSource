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
    func search(with text: String?)
    func loadMore()
    func resetData()
}

protocol EkoCommunitiesScreenViewModelDataSource {
    var communities: [EkoCommunityModel] { get }
    var loadingState: EkoLoadingState { get }
    func community(at indexPath: IndexPath) -> EkoCommunityModel
}

protocol EkoCommunitiesScreenViewModelDelegate: class {
    func screenViewModel(_ model: EkoCommunitiesScreenViewModelType, didUpdateCommunities communities: [EkoCommunityModel])
    func screenViewModel(_ model: EkoCommunitiesScreenViewModelType, didUpdateLoadingState loadingState: EkoLoadingState)
}

protocol EkoCommunitiesScreenViewModelType: EkoCommunitiesScreenViewModelAction, EkoCommunitiesScreenViewModelDataSource {
    var action: EkoCommunitiesScreenViewModelAction { get }
    var dataSource: EkoCommunitiesScreenViewModelDataSource { get }
    var delegate: EkoCommunitiesScreenViewModelDelegate? { get set }
}

extension EkoCommunitiesScreenViewModelType {
    var action: EkoCommunitiesScreenViewModelAction { return self }
    var dataSource: EkoCommunitiesScreenViewModelDataSource { return self }
}
