//
//  EkoRecommendedCommunityScreenViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 7/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

protocol EkoRecommendedCommunityScreenViewModelAction {
    func getRecommendedCommunity()
}

protocol EkoRecommendedCommunityScreenViewModelDataSource {
    var community: EkoBoxBinding<[EkoCommunityModel]> { get set }
    var isNoData: EkoBoxBinding<Bool> { get set }
    func item(at indexPath: IndexPath) -> EkoCommunityModel?
}

protocol EkoRecommendedCommunityScreenViewModelType: EkoRecommendedCommunityScreenViewModelAction, EkoRecommendedCommunityScreenViewModelDataSource {
    var action: EkoRecommendedCommunityScreenViewModelAction { get }
    var dataSource: EkoRecommendedCommunityScreenViewModelDataSource { get }
}

extension EkoRecommendedCommunityScreenViewModelType {
    var action: EkoRecommendedCommunityScreenViewModelAction { return self }
    var dataSource: EkoRecommendedCommunityScreenViewModelDataSource { return self }
}
