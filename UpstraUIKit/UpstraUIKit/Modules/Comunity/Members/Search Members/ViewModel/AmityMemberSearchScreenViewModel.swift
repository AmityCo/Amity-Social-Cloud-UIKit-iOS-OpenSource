//
//  AmityMemberSearchScreenViewModel.swift
//  AmityUIKit
//
//  Created by Hamlet on 11.05.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

final class AmityMemberSearchScreenViewModel: AmityMemberSearchScreenViewModelType {
    weak var delegate: AmityMemberSearchScreenViewModelDelegate?
    
    // MARK: - Manager
    private let memberListRepositoryManager: AmityMemberListRepositoryManagerProtocol
    
    // MARK: - Properties
    private let debouncer = Debouncer(delay: 0.3)
    private var memberList: [AmityUserModel] = []
    
    init(memberListRepositoryManager: AmityMemberListRepositoryManagerProtocol) {
        self.memberListRepositoryManager = memberListRepositoryManager
    }
}

// MARK: - DataSource
extension AmityMemberSearchScreenViewModel {
    func numberOfmembers() -> Int {
        return memberList.count
    }
    
    func item(at indexPath: IndexPath) -> AmityUserModel? {
        guard !memberList.isEmpty else { return nil }
        return memberList[indexPath.row]
    }
}

// MARK: - Action
extension AmityMemberSearchScreenViewModel {
    
    func search(withText text: String?) {
        memberList = []
        guard let text = text, !text.isEmpty else {
            delegate?.screenViewModelDidClearText(self)
            delegate?.screenViewModel(self, loadingState: .loaded)
            return
        }

        delegate?.screenViewModel(self, loadingState: .loading)
        memberListRepositoryManager.search(withText: text, sortyBy: .displayName) { [weak self] (memberList) in
            self?.debouncer.run {
                self?.prepareData(memberList: memberList)
            }
        }
    }
    
    private func prepareData(memberList: [AmityUserModel]) {
        self.memberList = memberList
        if memberList.isEmpty {
            delegate?.screenViewModelDidSearchNotFound(self)
        } else {
            delegate?.screenViewModelDidSearch(self)
        }
        delegate?.screenViewModel(self, loadingState: .loaded)
    }
    
    func loadMore() {
        memberListRepositoryManager.loadMore()
    }
}
