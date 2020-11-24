//
//  EkoCategoryPreviewScreenViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 7/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoCategoryPreviewScreenViewModelAction {
    func getCategory()
}

protocol EkoCategoryPreviewScreenViewModelDataSource {
    var categories: EkoBoxBinding<[EkoCommunityCategoryModel]> { get }
    func numberOfItem() -> Int
    func item(at indexPath: IndexPath) -> EkoCommunityCategoryModel
}

protocol EkoCategoryPreviewScreenViewModelType: EkoCategoryPreviewScreenViewModelAction, EkoCategoryPreviewScreenViewModelDataSource {
    var action: EkoCategoryPreviewScreenViewModelAction { get }
    var dataSource: EkoCategoryPreviewScreenViewModelDataSource { get }
}

extension EkoCategoryPreviewScreenViewModelType {
    var action: EkoCategoryPreviewScreenViewModelAction { return self }
    var dataSource: EkoCategoryPreviewScreenViewModelDataSource { return self }
}
