//
//  EkoRecommendedCommunityScreenViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 7/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

protocol EkoRecommendedCommunityScreenViewModelDelegate: class {
    func screenViewModel(_ viewModel: EkoRecommendedCommunityScreenViewModelType, didRetrieveRecommended recommended: [EkoCommunityModel], isEmpty: Bool)
    func screenViewModel(_ viewModel: EkoRecommendedCommunityScreenViewModelType, didFail error: EkoError)
}

protocol EkoRecommendedCommunityScreenViewModelDataSource {
    func community(at indexPath: IndexPath) -> EkoCommunityModel
    func numberOfRecommended() -> Int
}

protocol EkoRecommendedCommunityScreenViewModelAction {
    func retrieveRecommended()
}

protocol EkoRecommendedCommunityScreenViewModelType: EkoRecommendedCommunityScreenViewModelAction, EkoRecommendedCommunityScreenViewModelDataSource {
    var delegate: EkoRecommendedCommunityScreenViewModelDelegate? { get set }
    var action: EkoRecommendedCommunityScreenViewModelAction { get }
    var dataSource: EkoRecommendedCommunityScreenViewModelDataSource { get }
}

extension EkoRecommendedCommunityScreenViewModelType {
    var action: EkoRecommendedCommunityScreenViewModelAction { return self }
    var dataSource: EkoRecommendedCommunityScreenViewModelDataSource { return self }
}
