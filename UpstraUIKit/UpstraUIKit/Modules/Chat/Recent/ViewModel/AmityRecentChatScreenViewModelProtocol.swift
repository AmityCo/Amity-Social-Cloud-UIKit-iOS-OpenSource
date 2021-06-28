//
//  AmityRecentChatScreenViewModelProtocol.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 8/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityRecentChatScreenViewModelDelegate: class {
    func screenViewModelDidGetChannel()
    func screenViewModelLoadingState(for state: AmityLoadingState)
    func screenViewModelRoute(for route: AmityRecentChatScreenViewModel.Route)
    func screenViewModelEmptyView(isEmpty: Bool)
}

protocol AmityRecentChatScreenViewModelDataSource {
    
    func channel(at indexPath: IndexPath) -> AmityChannelModel
    func numberOfRow(in section: Int) -> Int
}

protocol AmityRecentChatScreenViewModelAction {
    func viewDidLoad()
    func join(at indexPath: IndexPath)
    func loadMore()
}

protocol AmityRecentChatScreenViewModelType: AmityRecentChatScreenViewModelAction, AmityRecentChatScreenViewModelDataSource {
    var action: AmityRecentChatScreenViewModelAction { get }
    var dataSource: AmityRecentChatScreenViewModelDataSource { get }
    var delegate: AmityRecentChatScreenViewModelDelegate? { get set }
}

extension AmityRecentChatScreenViewModelType {
    var action: AmityRecentChatScreenViewModelAction { return self }
    var dataSource: AmityRecentChatScreenViewModelDataSource { return self }
}
