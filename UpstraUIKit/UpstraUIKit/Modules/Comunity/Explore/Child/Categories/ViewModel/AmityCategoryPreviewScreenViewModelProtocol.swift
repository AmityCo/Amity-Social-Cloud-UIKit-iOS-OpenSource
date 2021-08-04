//
//  AmityCategoryPreviewScreenViewModelProtocol.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 7/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityCategoryPreviewCommunityScreenViewModelDelegate: AnyObject {
    func screenViewModel(_ viewModel: AmityCategoryPreviewScreenViewModelType, didRetrieveCategory category: [AmityCommunityCategoryModel], isEmpty: Bool)
    func screenViewModel(_ viewModel: AmityCategoryPreviewScreenViewModelType, didFail error: AmityError)
}

protocol AmityCategoryPreviewScreenViewModelDataSource {
    func category(at indexPath: IndexPath) -> AmityCommunityCategoryModel
    func numberOfCategory() -> Int
}

protocol AmityCategoryPreviewScreenViewModelAction {
    func retrieveCategory()
}

protocol AmityCategoryPreviewScreenViewModelType: AmityCategoryPreviewScreenViewModelAction, AmityCategoryPreviewScreenViewModelDataSource {
    var delegate: AmityCategoryPreviewCommunityScreenViewModelDelegate? { get set }
    var action: AmityCategoryPreviewScreenViewModelAction { get }
    var dataSource: AmityCategoryPreviewScreenViewModelDataSource { get }
}

extension AmityCategoryPreviewScreenViewModelType {
    var action: AmityCategoryPreviewScreenViewModelAction { return self }
    var dataSource: AmityCategoryPreviewScreenViewModelDataSource { return self }
}
