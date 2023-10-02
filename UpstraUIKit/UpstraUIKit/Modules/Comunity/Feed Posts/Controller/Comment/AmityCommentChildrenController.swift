//
//  AmityCommentChildrenController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 11/2/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import AmitySDK

final class AmityCommentChildrenController {
    
    private let postId: String
    private let commentRepository: AmityCommentRepository = AmityCommentRepository(client: AmityUIKitManagerInternal.shared.client)
    
    init(postId: String) {
        self.postId = postId
    }
    
    // MARK: - Data Handler
    
    private var commentChildrenCollections: [String: AmityCollection<AmityComment>] = [:]
    private var commentChildrenTokens: [String: AmityNotificationToken] = [:]
    private var commentChildrenResults: [String: [AmityCommentModel]] = [:]
    
    func childrenComments(for parentId: String) -> [AmityCommentModel] {
        return commentChildrenResults[parentId] ?? []
    }
    
    func fetchChildren(for parentId: String, completion: (() -> Void)?) {
        if let collection = commentChildrenCollections[parentId] {
            // if collection already existed, load more
            switch collection.loadingStatus {
            case .loaded:
                if collection.hasPrevious {
                    collection.previousPage()
                } else {
                    completion?()
                }
            default:
                break
            }
        } else {
            commentChildrenResults[parentId] = []
            let queryOptions = AmityCommentQueryOptions(referenceId: postId, referenceType: .post, filterByParentId: true, parentId: parentId, orderBy: .descending, includeDeleted: true)
            commentChildrenCollections[parentId] = commentRepository.getComments(with: queryOptions)
            commentChildrenTokens[parentId] = commentChildrenCollections[parentId]?.observe { [weak self] collection, _, _ in
                guard let strongSelf = self else { return }
                var commentModels: [AmityCommentModel] = []
                for i in 0..<collection.count() {
                    guard let childComment = collection.object(at: i) else { continue }
                    commentModels.append(AmityCommentModel(comment: childComment))
                }
                strongSelf.commentChildrenResults[parentId] = commentModels
                completion?()
            }
        }
    }
    
    func numberOfDeletedChildren(for parentId: String) -> Int {
        let comments = childrenComments(for: parentId).filter { $0.isDeleted }
        return comments.count
    }
    
    // MARK: - Pagination
    
    // number of visible item on the first load
    private let initialValue = 3
    
    // number of addition items on the next load
    private let pagination = 5
    
    // map of parentId with number of visible item
    // example: "comment_id_123": 8
    private var numberToShowMap: [String: Int] = [:]
    
    func increasePageNumber(for parentId: String) {
        numberToShowMap[parentId] = numberOfDisplayingItem(for: parentId) + pagination
    }
    
    func numberOfDisplayingItem(for parentId: String) -> Int {
        if let value = numberToShowMap[parentId] {
            return value
        }
        numberToShowMap[parentId] = initialValue
        return initialValue
    }
    
}
