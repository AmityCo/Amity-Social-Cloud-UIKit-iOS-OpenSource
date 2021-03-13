//
//  EkoCategoryPreviewScreenViewModel.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 7/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoCategoryPreviewScreenViewModel: EkoCategoryPreviewScreenViewModelType {

    weak var delegate: EkoCategoryPreviewCommunityScreenViewModelDelegate?
    
    // MARK: - Controller
    private let categoryController: EkoCommunityCategoryControllerProtocol
    
    // MARK: - Properties
    private var categories: [EkoCommunityCategoryModel] = []
    private let debouncer = Debouncer(delay: 0.3)
    
    init(categoryController: EkoCommunityCategoryControllerProtocol) {
        self.categoryController = categoryController
    }
    
}

// MARK: - DataSource
extension EkoCategoryPreviewScreenViewModel {
    
    func numberOfCategory() -> Int {
        return categories.count
    }
    
    func category(at indexPath: IndexPath) -> EkoCommunityCategoryModel {
        return categories[indexPath.row]
    }
}

// MARK: - Action
extension EkoCategoryPreviewScreenViewModel {

    func retrieveCategory() {
        categoryController.retrieve { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.debouncer.run {
                switch result {
                case .success(let category):
                    strongSelf.categories = category
                    strongSelf.delegate?.screenViewModel(strongSelf, didRetrieveCategory: category, isEmpty: category.isEmpty)
                case .failure(let error):
                    strongSelf.delegate?.screenViewModel(strongSelf, didFail: error)
                }
            }
        }
    }
    
}
