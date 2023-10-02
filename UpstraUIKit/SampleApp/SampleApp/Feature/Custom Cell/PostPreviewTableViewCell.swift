//
//  PostPreviewTableViewCell.swift
//  AmityUIKit
//
//  Created by Hamlet on 24.02.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

class PostPreviewTableViewCell: UITableViewCell {

    @IBOutlet private var postIdLabel: UILabel!
    @IBOutlet private var postDataTypeLabel: UILabel!
    @IBOutlet private var userIdLabel: UILabel!
    @IBOutlet private var dataLabel: UILabel!
    @IBOutlet private var reactionsCountLabel: UILabel!
    @IBOutlet private var myReactionsLabel: UILabel!
    @IBOutlet private var commentsCountLabel: UILabel!
    @IBOutlet private var deletedLabel: UILabel!
    @IBOutlet private var createdDateLabel: UILabel!

    func display(post: PostPreviewModel) {
        postIdLabel.text = "postId: \(post.postId)"
        postDataTypeLabel.text = "postDataType: \(post.dataType)"
        userIdLabel.text = "userId: \(post.userId)"
        dataLabel.text = "\(post.description)"
        reactionsCountLabel.text = "reactionsCount: \(post.reactionsCount)"
        myReactionsLabel.text = "myReactions: [\(post.myReactionsString)]"
        commentsCountLabel.text = "commentsCount: \(post.allCommentCount)"
        deletedLabel.text = "deleted: \(post.isDeleted)"
        createdDateLabel.text = "created: \(post.createdAt)"
    }
}
