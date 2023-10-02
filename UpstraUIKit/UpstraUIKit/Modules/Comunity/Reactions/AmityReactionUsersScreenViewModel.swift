//
//  AmityReactionUsersScreenViewModel.swift
//  AmityUIKit
//
//  Created by Amity on 26/4/2566 BE.
//  Copyright © 2566 BE Amity. All rights reserved.
//

import Foundation
import AmitySDK

struct ReactionUser {
    let userId: String
    let displayName: String
    let avatarURL: String
    
    init(reaction: AmityReaction) {
        self.userId = reaction.creator?.userId ?? ""
        self.displayName = reaction.creator?.displayName ?? ""
        self.avatarURL = reaction.creator?.getAvatarInfo()?.fileURL ?? ""
    }
    
    init(userId: String, displayName: String, avatarURL: String) {
        self.userId = userId
        self.displayName = displayName
        self.avatarURL = ""
    }
}

class AmityReactionUsersScreenViewModel {
    
    enum ScreenState {
        // When screen is opened for the first time.
        case initial
        
        // Data is being fetched from server
        // If pagination is true, show loadingIndicator at bottom of tableView.
        case loading(isPagination: Bool)

        // Data is fetched from server.
        // If data is [] -> Show Empty state
        // If error is not empty -> Show popup error
        case loaded(data: [ReactionUser], error: AmityError?)
        
        var canFetchData: Bool {
            switch self {
            case .initial, .loaded:
                return true
                
            case .loading:
                return false
            }
        }
    }
    
    private(set) var currentScreenState: ScreenState = .initial
    
    var observeScreenState: ((AmityReactionUsersScreenViewModel.ScreenState) -> Void)? {
        didSet {
            observeScreenState?(.initial)
        }
    }
    
    var reactionList = [ReactionUser]()
    
    private let reactionInfo: AmityReactionInfo
    private let reactionRepository: AmityReactionRepository
    
    private var liveCollection: AmityCollection<AmityReaction>?
    private var token: AmityNotificationToken?
    
    private var isLoadingDummyData = false
    
    init(info: AmityReactionInfo) {
        self.reactionInfo = info
        self.reactionRepository = AmityReactionRepository(client: AmityUIKitManagerInternal.shared.client)
    }
    
    func fetchUserList() {
        // Check if we can fetch data in current screen state
        guard currentScreenState.canFetchData else { return }
        
        // Change state to loading
        setupScreenState(state: .loading(isPagination: false))
        
        // Invalidate previous token
        token?.invalidate()
        liveCollection = nil
        
        // Query reactions
        liveCollection = reactionRepository.getReactions(reactionInfo.referenceId, referenceType: reactionInfo.referenceType, reactionName: AmityReactionType.like.rawValue)
        token = liveCollection?.observe({ [weak self] liveCollection, _, error in
            guard let weakSelf = self else { return }

            if let error {
                let sdkError = AmityError(error: error) ?? .unknown
                // Change state
                weakSelf.reactionList = weakSelf.isLoadingDummyData ? [] : weakSelf.reactionList
                weakSelf.setupScreenState(state: .loaded(data: weakSelf.reactionList, error: sdkError))
                weakSelf.isLoadingDummyData = false
            } else {
                let allObjects = liveCollection.allObjects()
                weakSelf.reactionList = allObjects.map { ReactionUser(reaction: $0) }
                
                // Change state
                weakSelf.setupScreenState(state: .loaded(data: weakSelf.reactionList, error: nil))
                weakSelf.isLoadingDummyData = false
            }
        })
    }
    
    func loadMoreUsers() {
        // Check if we can fetch data in current state
        guard currentScreenState.canFetchData else { return }

        // Check if collection has more data
        guard let collection = liveCollection, collection.hasNext else { return }
        
        // Change state
        setupScreenState(state: .loading(isPagination: true))
        
        // Fetch next page
        collection.nextPage()
    }
    
    private func setupScreenState(state: ScreenState) {
        self.currentScreenState = state
        self.observeScreenState?(currentScreenState)
    }
    
    /// Used for skeleton loading purpose
    func loadDummyDataSet() {
        self.reactionList = Array(repeating: ReactionUser(userId: "", displayName: "", avatarURL: ""), count: 15)
        self.isLoadingDummyData = true
    }
}
