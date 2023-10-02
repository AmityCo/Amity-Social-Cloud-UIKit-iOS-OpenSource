//
//  AmityCommentViewLayout.swift
//  AmityUIKit
//
//  Created by Amity on 4/11/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation

protocol AmityCommentLayoutSpace {
    var avatarLeading: CGFloat { get }
    var aboveAvatar: CGFloat { get }
    var avatarViewWidth: CGFloat { get }
    var belowContent: CGFloat { get }
    var aboveStack: CGFloat { get }
    var belowStack: CGFloat { get }
}

extension AmityCommentView {
    
    struct Layout {
        
        enum LayoutType {
            case comment
            case commentPreview
            case reply
        }
        
        let type: LayoutType
        let isExpanded: Bool
        let shouldShowActions: Bool
        let shouldLineShow: Bool
        
        var space: AmityCommentLayoutSpace {
            switch type {
            case .comment: return CommentSpace()
            case .commentPreview: return CommentPreviewSpace()
            case .reply: return ReplySpace()
            }
        }
        
        func shouldShowViewReplyButton(for comment: AmityCommentModel) -> Bool {
            switch type {
            case .commentPreview:
                return comment.isChildrenExisted
            default:
                return false
            }
        }
        
    }
    
}

private struct CommentSpace: AmityCommentLayoutSpace {
    let avatarLeading: CGFloat = 16
    let aboveAvatar: CGFloat = 16
    let avatarViewWidth: CGFloat = 28
    let belowContent: CGFloat = 12
    let aboveStack: CGFloat = 8
    let belowStack: CGFloat = 12
}

private struct CommentPreviewSpace: AmityCommentLayoutSpace {
    let avatarLeading: CGFloat = 16
    let aboveAvatar: CGFloat = 16
    let avatarViewWidth: CGFloat = 28
    let belowContent: CGFloat = 12
    let aboveStack: CGFloat = 8
    let belowStack: CGFloat = 12
}

private struct ReplySpace: AmityCommentLayoutSpace {
    let avatarLeading: CGFloat = 52
    let aboveAvatar: CGFloat = 0
    let avatarViewWidth: CGFloat = 28
    let belowContent: CGFloat = 12
    let aboveStack: CGFloat = 8
    let belowStack: CGFloat = 12
}
