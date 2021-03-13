//
//  EkoCategoryPreviewScreenViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 7/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoCategoryPreviewCommunityScreenViewModelDelegate: class {
    func screenViewModel(_ viewModel: EkoCategoryPreviewScreenViewModelType, didRetrieveCategory category: [EkoCommunityCategoryModel], isEmpty: Bool)
    func screenViewModel(_ viewModel: EkoCategoryPreviewScreenViewModelType, didFail error: EkoError)
}

protocol EkoCategoryPreviewScreenViewModelDataSource {
    func category(at indexPath: IndexPath) -> EkoCommunityCategoryModel
    func numberOfCategory() -> Int
}

protocol EkoCategoryPreviewScreenViewModelAction {
    func retrieveCategory()
}

protocol EkoCategoryPreviewScreenViewModelType: EkoCategoryPreviewScreenViewModelAction, EkoCategoryPreviewScreenViewModelDataSource {
    var delegate: EkoCategoryPreviewCommunityScreenViewModelDelegate? { get set }
    var action: EkoCategoryPreviewScreenViewModelAction { get }
    var dataSource: EkoCategoryPreviewScreenViewModelDataSource { get }
}

extension EkoCategoryPreviewScreenViewModelType {
    var action: EkoCategoryPreviewScreenViewModelAction { return self }
    var dataSource: EkoCategoryPreviewScreenViewModelDataSource { return self }
}
