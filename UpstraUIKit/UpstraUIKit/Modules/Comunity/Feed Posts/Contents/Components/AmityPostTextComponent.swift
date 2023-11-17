//
//  AmityPostTextComponent.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/11/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
/**
 This is a default component for providing to display a `Text` post
 
 # Consists of 4 cells
 - `AmityPostHeaderTableViewCell`
 - `AmityPostTextTableViewCell`
 - `AmityPostFooterTableViewCell`
 - `AmityPostPreviewCommentTableViewCell`
 */
public struct AmityPostTextComponent: AmityPostComposable {

    private(set) public var post: AmityPostModel
    
    private var hasPreviewLink: Bool {
        return AmityPreviewLinkWizard.shared.detectLinks(input: post.text).count > 0
    }
    
    public init(post: AmityPostModel) {
        self.post = post
    }
    
    public func getComponentCount(for index: Int) -> Int {
        switch post.appearance.displayType {
        case .feed:
            return AmityPostConstant.defaultNumberComponent + post.maximumLastestComments + post.viewAllCommentSection + (hasPreviewLink ? 1 : 0)
        case .postDetail:
            return AmityPostConstant.defaultNumberComponent + (hasPreviewLink ? 1 : 0)
        }
    }
    
    public func getComponentCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        if hasPreviewLink {
            switch indexPath.row {
            case 0:
                let cell: AmityPostHeaderTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.display(post: post)
                return cell
                
            case 1:
                let cell: AmityPostTextTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.display(post: post, indexPath: indexPath)
                return cell
                
            case 2:
                let cell: AmityPreviewLinkCell = tableView.dequeueReusableCell(for: indexPath)
                cell.display(post: post)
                return cell

                
            case 3:
                let cell: AmityPostFooterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.display(post: post)
                return cell
                
            case 4,5:
                let cell: AmityPostPreviewCommentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                let comment = post.getComment(at: indexPath, totalComponent: AmityPostConstant.defaultNumberComponent + 1) // plus 1 as it has preview link component
                let isExpanded = post.commentExpandedIds.contains(comment?.id ?? "absolutely-cannot-found-xc")
                cell.setIsExpanded(isExpanded)
                cell.display(post: post, comment: comment)
                return cell
                
            default:
                let cell: AmityPostViewAllCommentsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                return cell
            }
        } else {
            switch indexPath.row {
            case 0:
                let cell: AmityPostHeaderTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.display(post: post)
                return cell
                
            case 1:
                let cell: AmityPostTextTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.display(post: post, indexPath: indexPath)
                return cell
                
            case 2:
                let cell: AmityPostFooterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.display(post: post)
                return cell
                
            case AmityPostConstant.defaultNumberComponent + post.maximumLastestComments:
                let cell: AmityPostViewAllCommentsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                return cell
                
            default:
                let cell: AmityPostPreviewCommentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                let comment = post.getComment(at: indexPath, totalComponent: AmityPostConstant.defaultNumberComponent)
                let isExpanded = post.commentExpandedIds.contains(comment?.id ?? "absolutely-cannot-found-xc")
                cell.setIsExpanded(isExpanded)
                cell.display(post: post, comment: comment)
                return cell
            }
        }
    }
    
    public func getComponentHeight(indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
