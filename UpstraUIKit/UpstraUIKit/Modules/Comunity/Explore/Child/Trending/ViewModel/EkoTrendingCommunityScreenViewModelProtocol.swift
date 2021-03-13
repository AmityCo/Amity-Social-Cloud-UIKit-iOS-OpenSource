//
//  EkoTrendingCommunityScreenViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 7/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

protocol EkoTrendingCommunityScreenViewModelDelegate: class {
    func screenViewModel(_ viewModel: EkoTrendingCommunityScreenViewModelType, didRetrieveTrending trending: [EkoCommunityModel], isEmpty: Bool)
    func screenViewModel(_ viewModel: EkoTrendingCommunityScreenViewModelType, didFail error: EkoError)
}

protocol EkoTrendingCommunityScreenViewModelDataSource {
    func community(at indexPath: IndexPath) -> EkoCommunityModel
    func numberOfTrending() -> Int
}

protocol EkoTrendingCommunityScreenViewModelAction {
    func retrieveTrending()
}

protocol EkoTrendingCommunityScreenViewModelType: EkoTrendingCommunityScreenViewModelAction, EkoTrendingCommunityScreenViewModelDataSource {
    var delegate: EkoTrendingCommunityScreenViewModelDelegate? { get set }
    var action: EkoTrendingCommunityScreenViewModelAction { get }
    var dataSource: EkoTrendingCommunityScreenViewModelDataSource { get }
}

extension EkoTrendingCommunityScreenViewModelType {
    var action: EkoTrendingCommunityScreenViewModelAction { return self }
    var dataSource: EkoTrendingCommunityScreenViewModelDataSource { return self }
}
