//
//  AmityPendingPostsComponent.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 9/7/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

struct AmityPendingPostsComponent: AmityPostComposable {
    
    private enum Sections: Int, CaseIterable {
        case header = 0
        case body
        case action
        
        static let componentOfAdmin = 3
        static let componentOfMember = 2
    }
    
    let post: AmityPostModel
    private var hasEditCommunityPermission: Bool = false
    
    init(post: AmityPostModel) {
        self.post = post
    }
    
    init(post: AmityPostModel, hasEditCommunityPermission: Bool) {
        self.post = post
        self.hasEditCommunityPermission = hasEditCommunityPermission
    }
    
    func getComponentCount(for index: Int) -> Int {
        if hasEditCommunityPermission {
            return Sections.componentOfAdmin
        } else {
            return Sections.componentOfMember
        }
    }
    
    func getComponentCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let section = Sections(rawValue: indexPath.row) else { return UITableViewCell() }
        switch section {
        case .header:
            let cell: AmityPostHeaderTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.display(post: post)
            return cell
        case .body:
            switch post.dataTypeInternal {
            case .text:
                let cell: AmityPostTextTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.display(post: post, indexPath: indexPath)
                return cell
            case .image, .video:
                let cell: AmityPostGalleryTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.display(post: post, indexPath: indexPath)
                return cell
            case .liveStream:
                let cell: AmityPostLiveStreamTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.display(post: post, indexPath: indexPath)
                return cell
            case .file:
                let cell: AmityPostFileTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.display(post: post, indexPath: indexPath)
                return cell
            case .poll:
                let cell: AmityPostPollTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.display(post: post, indexPath: indexPath)
                return cell
            case .unknown:
                return UITableViewCell()
            }
        case .action:
            let cell: AmityPendingPostsActionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.updatePost(withPost: post)
            return cell
        }
    }
    
    func getComponentHeight(indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
