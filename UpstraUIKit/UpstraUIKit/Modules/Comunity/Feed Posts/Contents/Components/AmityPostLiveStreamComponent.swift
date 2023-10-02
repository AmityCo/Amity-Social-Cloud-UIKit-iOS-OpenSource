//
//  AmityPostLiveStreamComponent.swift
//  AmityUIKit
//
//  Created by Nutchaphon Rewik on 7/9/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

/**
 This is a default component for providing to display a `LiveStream` post
 - `AmityPostHeaderTableViewCell`
 - `AmityPostTextTableViewCell`
 - `AmityPostLiveStreamTableViewCell`
 - `AmityPostFooterTableViewCell`
 - `AmityPostPreviewCommentTableViewCell`
 - `AmityPostViewAllCommentsTableViewCell`
 */
public struct AmityPostLiveStreamComponent: AmityPostComposable {
    
    private(set) public var post: AmityPostModel
    
    enum SubCell: Int, CaseIterable {
        case header
        case text
        case liveStream
        case footer
        case commentPreview
        case viewAllComment
    }
    
    private var contentsDataSource: [SubCell] = []
    private var commentsDataSource: [SubCell] = []
    private var wholePostDataSource: [SubCell] = []

    public init(post: AmityPostModel) {
        
        self.post = post
        
        // Prepare data source
        contentsDataSource = [.header, .text, .liveStream, .footer]
        
        switch post.appearance.displayType {
        case .feed:
            if post.maximumLastestComments > 0 {
                let commentPreviews = (0..<post.maximumLastestComments).map { _ in
                    SubCell.commentPreview
                }
                commentsDataSource.append(contentsOf: commentPreviews)
            }
            if post.viewAllCommentSection > 0 {
                commentsDataSource.append(.viewAllComment)
            }
        case .postDetail:
            break
        }
        
        wholePostDataSource = contentsDataSource + commentsDataSource
        
    }
    
    public func getComponentCount(for index: Int) -> Int {
        return wholePostDataSource.count
    }
    
    public func getComponentCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let subCell = wholePostDataSource[indexPath.row]
        switch subCell {
        case .header:
            let cell: AmityPostHeaderTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.display(post: post)
            return cell
        case .text:
            let cell: AmityPostTextTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.display(post: post, indexPath: indexPath)
            return cell
        case .liveStream:
            let cell: AmityPostLiveStreamTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.display(post: post, indexPath: indexPath)
            return cell
        case .footer:
            let cell: AmityPostFooterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.display(post: post)
            return cell
        case .commentPreview:
            let cell: AmityPostPreviewCommentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            let comment = post.getComment(at: indexPath, totalComponent: contentsDataSource.count)
            let isExpanded = post.commentExpandedIds.contains(comment?.id ?? "absolutely-cannot-found-xc")
            cell.setIsExpanded(isExpanded)
            cell.display(post: post, comment: comment)
            return cell
        case .viewAllComment:
            let cell: AmityPostViewAllCommentsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }
    
    public func getComponentHeight(indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

