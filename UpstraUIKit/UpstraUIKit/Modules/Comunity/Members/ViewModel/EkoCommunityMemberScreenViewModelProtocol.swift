//
//  EkoCommunityMemberScreenViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 15/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

protocol EkoCommunityMemberScreenViewModelDataSource {
    var membership: EkoBoxBinding<EkoCollection<EkoCommunityMembership>?> { get set }
    var cellAction: EkoBoxBinding<EkoCommunityMemberScreenViewModel.CellAction?> { get set }
    var loading: EkoBoxBinding<EkoLoadingState> { get set }
    
    func numberOfMembers() -> Int
    func item(at indexPath: IndexPath) -> EkoCommunityMembership?
}

protocol EkoCommunityMemberScreenViewModelAction {
    func getMember()
    func selectedItem(action: EkoCommunityMemberScreenViewModel.CellAction)
    func loadMore()
}

protocol EkoCommunityMemberScreenViewModelType: EkoCommunityMemberScreenViewModelAction, EkoCommunityMemberScreenViewModelDataSource {
    var action: EkoCommunityMemberScreenViewModelAction { get }
    var dataSource: EkoCommunityMemberScreenViewModelDataSource { get }
}

extension EkoCommunityMemberScreenViewModelType {
    var action: EkoCommunityMemberScreenViewModelAction { return self }
    var dataSource: EkoCommunityMemberScreenViewModelDataSource { return self }
}
