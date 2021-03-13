//
//  EkoPostTextComponent.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/11/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit
/**
 This is a default component for providing to display a `Text` post
 
 # Consists of 4 cells
 - `EkoPostHeaderTableViewCell`
 - `EkoPostTextTableViewCell`
 - `EkoPostFooterTableViewCell`
 - `EkoPostPreviewCommentTableViewCell`
 */
public struct EkoPostTextComponent: EkoPostComposable {

    private(set) public var post: EkoPostModel
    
    public init(post: EkoPostModel) {
        self.post = post
    }
    
    public func getComponentCount(for index: Int) -> Int {
        switch post.displayType {
        case .feed:
            return EkoPostConstant.defaultNumberComponent + post.maximumLastestComments + post.viewAllCommentSection
        case .postDetail:
            return EkoPostConstant.defaultNumberComponent
        }
    }
    
    public func getComponentCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: EkoPostHeaderTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.display(post: post, shouldShowOption: post.shouldShowOption)
            return cell
        case 1:
            let cell: EkoPostTextTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.display(post: post, shouldExpandContent: post.shouldContentExpand, indexPath: indexPath)
            return cell
        case 2:
            let cell: EkoPostFooterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.display(post: post)
            return cell
        case EkoPostConstant.defaultNumberComponent + post.maximumLastestComments:
            let cell: EkoPostViewAllCommentsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        default:
            let cell: EkoPostPreviewCommentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.display(post: post, comment: post.getComment(at: indexPath, totalComponent: EkoPostConstant.defaultNumberComponent))
            return cell
        }
    }
    
    public func getComponentHeight(indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
