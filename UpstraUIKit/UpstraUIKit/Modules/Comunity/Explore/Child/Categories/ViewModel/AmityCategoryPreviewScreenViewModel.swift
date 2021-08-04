//
//  AmityCategoryPreviewScreenViewModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 7/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

final class AmityCategoryPreviewScreenViewModel: AmityCategoryPreviewScreenViewModelType {

    weak var delegate: AmityCategoryPreviewCommunityScreenViewModelDelegate?
    
    // MARK: - Controller
    private let categoryController: AmityCommunityCategoryControllerProtocol
    
    // MARK: - Properties
    private var categories: [AmityCommunityCategoryModel] = []
    private let debouncer = Debouncer(delay: 0.3)
    
    init(categoryController: AmityCommunityCategoryControllerProtocol) {
        self.categoryController = categoryController
    }
    
}

// MARK: - DataSource
extension AmityCategoryPreviewScreenViewModel {
    
    func numberOfCategory() -> Int {
        return categories.count
    }
    
    func category(at indexPath: IndexPath) -> AmityCommunityCategoryModel {
        return categories[indexPath.row]
    }
}

// MARK: - Action
extension AmityCategoryPreviewScreenViewModel {

    func retrieveCategory() {
        categoryController.retrieve { [weak self] (result) in
            self?.debouncer.run {
                guard let strongSelf = self else { return }
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
