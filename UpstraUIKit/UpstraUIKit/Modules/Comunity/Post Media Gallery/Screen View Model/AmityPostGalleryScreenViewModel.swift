//
//  AmityPostGalleryScreenViewModel.swift
//  AmityUIKit
//
//  Created by Nutchaphon Rewik on 4/8/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import Foundation
import AmitySDK

class AmityPostGalleryScreenViewModel {
    
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

    
    weak var delegate: AmityPostGalleryScreenViewModelDelegate?
    
    private var items: Array<[AmityPostGalleryScreenViewModel.Item]> = []
    
    private var postRepository: AmityPostRepository?
    
    private var posts: AmityCollection<AmityPost>?
    private var token: AmityNotificationToken?
    
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
        var newItems: Array<[AmityPostGalleryScreenViewModel.Item]> = []
        //      1. First section
        var firstSection: [AmityPostGalleryScreenViewModel.Item] = []
        firstSection.append(.segmentedControl)
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
        delegate?.screenViewModelDidUpdateDataSource(self)
    }
    
}

extension AmityPostGalleryScreenViewModel: AmityPostGalleryScreenViewModelAction {
    
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
    
    func loadMore() {
        posts?.nextPage()
    }
    
}

extension AmityPostGalleryScreenViewModel: AmityPostGalleryScreenViewModelDataSource {
    
    func numberOfSections() -> Int {
        items.count
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        items[section].count
    }
    
    func item(at indexPath: IndexPath) -> AmityPostGalleryScreenViewModel.Item {
        items[indexPath.section][indexPath.row]
    }
    
}

extension AmityPostGalleryScreenViewModel: AmityPostGalleryScreenViewModelType {
    
    var action: AmityPostGalleryScreenViewModelAction {
        self
    }
    
    var dataSource: AmityPostGalleryScreenViewModelDataSource {
        self
    }
    
}
