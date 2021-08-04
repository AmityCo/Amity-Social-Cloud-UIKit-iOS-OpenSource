//
//  AmityMyCommunityScreenViewModelProtocol.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 26/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

protocol AmityMyCommunityScreenViewModelDelegate: AnyObject {
    func screenViewModelDidRetrieveAllCommunity(_ viewModel: AmityMyCommunityScreenViewModelType)
    func screenViewModelDidSearch(_ viewModel: AmityMyCommunityScreenViewModelType)
    func screenViewModelDidSearchNotFound(_ viewModel: AmityMyCommunityScreenViewModelType)
    func screenViewModelDidSearchCancel(_ viewModel: AmityMyCommunityScreenViewModelType)
    func screenViewModel(_ viewModel: AmityMyCommunityScreenViewModelType, loadingState: AmityLoadingState)
}

protocol AmityMyCommunityScreenViewModelDataSource {
    var searchText: String { get }
    
    func numberOfCommunity() -> Int
    func item(at indexPath: IndexPath) -> AmityCommunityModel?
}

protocol AmityMyCommunityScreenViewModelAction {
    func retrieveAllCommunity()
    func search(withText text: String?)
    func searchCancel()
    func loadMore()
}

protocol AmityMyCommunityScreenViewModelType: AmityMyCommunityScreenViewModelAction, AmityMyCommunityScreenViewModelDataSource {
    var delegate: AmityMyCommunityScreenViewModelDelegate? { get set }
    var action: AmityMyCommunityScreenViewModelAction { get }
    var dataSource: AmityMyCommunityScreenViewModelDataSource { get }
}

extension AmityMyCommunityScreenViewModelType {
    var action: AmityMyCommunityScreenViewModelAction { return self }
    var dataSource: AmityMyCommunityScreenViewModelDataSource { return self }
}
