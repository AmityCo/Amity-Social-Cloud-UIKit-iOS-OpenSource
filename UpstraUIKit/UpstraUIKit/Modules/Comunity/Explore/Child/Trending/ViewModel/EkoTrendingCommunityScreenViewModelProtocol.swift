//
//  EkoTrendingCommunityScreenViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 7/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

protocol EkoTrendingCommunityScreenViewModelAction {
    func getTrending()
}

protocol EkoTrendingCommunityScreenViewModelDataSource {
    var community: EkoBoxBinding<[EkoCommunityModel]> { get set }
    func item(at indexPath: IndexPath) -> EkoCommunityModel?
}

protocol EkoTrendingCommunityScreenViewModelType: EkoTrendingCommunityScreenViewModelAction, EkoTrendingCommunityScreenViewModelDataSource {
    var action: EkoTrendingCommunityScreenViewModelAction { get }
    var dataSource: EkoTrendingCommunityScreenViewModelDataSource { get }
}

extension EkoTrendingCommunityScreenViewModelType {
    var action: EkoTrendingCommunityScreenViewModelAction { return self }
    var dataSource: EkoTrendingCommunityScreenViewModelDataSource { return self }
}
