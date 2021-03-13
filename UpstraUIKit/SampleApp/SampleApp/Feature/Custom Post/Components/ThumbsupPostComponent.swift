//
//  ThumbsupPostComponent.swift
//  SampleApp
//
//  Created by sarawoot khunsri on 2/16/21.
//  Copyright © 2021 Eko. All rights reserved.
//

import UIKit
import UpstraUIKit

struct ThumbsupPostComponent: EkoPostComposable {
    
    var post: EkoPostModel
    
    init(post: EkoPostModel) {
        self.post = post
    }
    
    func getComponentCount(for index: Int) -> Int {
        switch post.displayType {
        case .feed:
            return 2 + post.maximumLastestComments + post.viewAllCommentSection
        case .postDetail:
            return 2
        @unknown default:
            return 0
        }
    }
    
    func getComponentCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EkoPostThumbsupTableViewCell", for: indexPath) as! EkoPostThumbsupTableViewCell
            cell.display(withPost: post)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EkoPostFooterTableViewCell", for: indexPath) as! EkoPostFooterTableViewCell
            cell.display(post: post)
            return cell
        case 2 + post.maximumLastestComments:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EkoPostViewAllCommentsTableViewCell", for: indexPath) as! EkoPostViewAllCommentsTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EkoPostPreviewCommentTableViewCell", for: indexPath) as! EkoPostPreviewCommentTableViewCell
            cell.display(post: post, comment: post.getComment(at: indexPath, totalComponent: 2))
            return cell
        }
        
    }
    
    func getComponentHeight(indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
