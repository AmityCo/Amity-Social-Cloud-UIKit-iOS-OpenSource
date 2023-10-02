//
//  AmityTrendingCommunityScreenViewModelProtocol.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 7/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

protocol AmityTrendingCommunityScreenViewModelDelegate: AnyObject {
    func screenViewModel(_ viewModel: AmityTrendingCommunityScreenViewModelType, didRetrieveTrending trending: [AmityCommunityModel], isEmpty: Bool)
    func screenViewModel(_ viewModel: AmityTrendingCommunityScreenViewModelType, didFail error: AmityError)
}

protocol AmityTrendingCommunityScreenViewModelDataSource {
    func community(at indexPath: IndexPath) -> AmityCommunityModel
    func numberOfTrending() -> Int
}

protocol AmityTrendingCommunityScreenViewModelAction {
    func retrieveTrending()
}

protocol AmityTrendingCommunityScreenViewModelType: AmityTrendingCommunityScreenViewModelAction, AmityTrendingCommunityScreenViewModelDataSource {
    var delegate: AmityTrendingCommunityScreenViewModelDelegate? { get set }
    var action: AmityTrendingCommunityScreenViewModelAction { get }
    var dataSource: AmityTrendingCommunityScreenViewModelDataSource { get }
}

extension AmityTrendingCommunityScreenViewModelType {
    var action: AmityTrendingCommunityScreenViewModelAction { return self }
    var dataSource: AmityTrendingCommunityScreenViewModelDataSource { return self }
}
