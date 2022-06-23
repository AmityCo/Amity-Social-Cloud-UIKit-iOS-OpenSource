//
//  AmityDiscoveryScreenViewModel.swift
//  AmityUIKit
//
//  Created by Mono TheForestcat on 18/2/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation
import AmitySDK

class AmityDiscoveryScreenViewModel {
    
    enum Item {
        /// PostGallerySegmentedControlCell; allowing user to switch the section.
        case segmentedControl
        /// PostGalleryItemCell to show in gallery
        case post(AmityPost)
        /// Show empty view post item
        case fakePost
        ///
        case empty
    }

    
    weak var delegate: AmityDiscoveryScreenViewModelDelegate?
    
    private var items: Array<[AmityDiscoveryScreenViewModel.Item]> = []
    
    private var discoveryItems: [DiscoveryDataModel] = []
    
    private var postRepository: AmityPostRepository?
    
    private var posts: AmityCollection<AmityPost>?
    private var token: AmityNotificationToken?
    private var paginateNumber: Int = 1
    
    func setup(postRepository: AmityPostRepository) {
        self.postRepository = postRepository
    }
    
    private func updateAndRebuildDataSource() {
        guard let posts = posts else {
            assertionFailure("post must be ready at this point.")
            return
        }
        // Query all the posts from the live collection
        var allPosts: [AmityPost] = []
        for index in (0..<posts.count()) {
            if let post = posts.object(at: index) {
                allPosts.append(post)
            }
        }
        // Rebuild new datasource items
        var newItems: Array<[AmityDiscoveryScreenViewModel.Item]> = []
        //      1. First section
        var firstSection: [AmityDiscoveryScreenViewModel.Item] = []
//        firstSection.append(.segmentedControl)
        if !allPosts.isEmpty {
            firstSection.append(
                contentsOf: allPosts.map { .post($0) }
            )
        } else {
            firstSection.append(.empty)
        }
        if allPosts.count % 2 != 0 {
            // Fake blank post, to align layout in 2 collumn for each row.
            firstSection.append(.fakePost)
        }
        
        // HACK: To increase content size, we add fake post.
        // This make gallery page scrollable, even if there's no item to scroll.
        //
        let minimItemToMakeTheScreenScrollableProperly = max(0, 10 - allPosts.count)
        (0..<minimItemToMakeTheScreenScrollableProperly).forEach { _ in
            firstSection.append(.fakePost)
        }
        
        newItems.append(firstSection)
        // Update datasource and notify
        items = newItems
        
        self.delegate?.screenViewModelDidUpdateDataSource(self)
        
    }
    
    func getDiscoveryItem(){
        customAPIRequest.getDiscoveryData(page_number: paginateNumber) { discoveryArray in
//            let shuffleDiscoveryArray = discoveryArray.shuffled()
            self.discoveryItems.append(contentsOf: discoveryArray)
            DispatchQueue.main.async {
                AmityHUD.hide()
                self.delegate?.screenViewModelDidUpdateDataSource(self)
            }
        }
    }
    
}

extension AmityDiscoveryScreenViewModel: AmityDiscoveryScreenViewModelAction {
    
    func switchPostsQuery(to options: AmityPostQueryOptions) {
        guard let postRepository = postRepository else {
            assertionFailure("postRepository must be ready at this point.")
            return
        }
        posts = postRepository.getPosts(options)
        
        token = posts?.observe { [weak self] _, changes, error in
            self?.updateAndRebuildDataSource()
        }
    }
    
    func loadDiscoveryItem() {
        getDiscoveryItem()
    }
    
    func loadMore() {
        paginateNumber += 1
        customAPIRequest.getDiscoveryData(page_number: paginateNumber) { discoveryArray in
            let shuffleDiscoveryArray = discoveryArray.shuffled()
            self.discoveryItems.append(contentsOf: shuffleDiscoveryArray)
            DispatchQueue.main.async {
                AmityHUD.hide()
                self.delegate?.screenViewModelDidUpdateDataSource(self)
            }
        }
    }
    
}

extension AmityDiscoveryScreenViewModel: AmityDiscoveryScreenViewModelDataSource {
    
    func numberOfSections() -> Int {
//        items.count
        return 1
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
//        items[section].count
        discoveryItems.count
    }
    
    func item(at indexPath: IndexPath) -> AmityDiscoveryScreenViewModel.Item {
        items[indexPath.section][indexPath.row]
    }
    
    func discoveryItem(at indexPath: IndexPath) -> DiscoveryDataModel {
        discoveryItems[indexPath.row]
    }
    
}

extension AmityDiscoveryScreenViewModel: AmityDiscoveryScreenViewModelType {

    var action: AmityDiscoveryScreenViewModelAction {
        self
    }
    
    var dataSource: AmityDiscoveryScreenViewModelDataSource {
        self
    }
    
}
