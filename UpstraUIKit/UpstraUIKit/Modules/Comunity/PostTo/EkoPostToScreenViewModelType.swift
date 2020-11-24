//
//  EkoPostToScreenViewModelType.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 27/8/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoPostToScreenViewModelDataSource {
    func numberOfItems() -> Int
    func community(at indexPath: IndexPath) -> EkoCommunityModel?
    func loadNext()
}

protocol EkoPostToScreenViewModelDelegate: class {
    func screenViewModelDidUpdateItems(_ viewModel: EkoPostToScreenViewModel)
}

protocol EkoPostToScreenViewModelAction {
}

protocol EkoPostToScreenViewModelType: EkoPostToScreenViewModelAction, EkoPostToScreenViewModelDataSource {
    var action: EkoPostToScreenViewModelAction { get }
    var dataSource: EkoPostToScreenViewModelDataSource { get }
    var delegate: EkoPostToScreenViewModelDelegate? { get set }
}

extension EkoPostToScreenViewModelType {
    var action: EkoPostToScreenViewModelAction { return self }
    var dataSource: EkoPostToScreenViewModelDataSource { return self }
}
