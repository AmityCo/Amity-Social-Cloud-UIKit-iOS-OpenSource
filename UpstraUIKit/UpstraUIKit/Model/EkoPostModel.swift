//
//  EkoPostModel.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 20/7/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import EkoChat
import UIKit

public class EkoPostModel {
    
    enum DataType: String {
        case text = "text"
        case image = "image"
        case file = "file"
    }
    
    private(set) var post: EkoPost
    
    var text: String?
    var images: [EkoImage] = []
    var files: [EkoFile] = []
    var latestComments: [EkoCommentModel] = []
    let postAsModerator: Bool = false
    
    // Maps fileId to PostId for child post
    private var fileMap = [String: String]()
    
    public init(post: EkoPost) {
        self.post = post
        self.extractPostInfo()
        self.latestComments = post.latestComments.map(EkoCommentModel.init)
    }
    
    // Each post has a property called childrenPosts. This contains an array of EkoPost object.
    // If a post contains files or images, those are present as children posts. So we need
    // to go through that array to determine the post type.
    func extractPostInfo() {
        // Get Text
        self.text = post.data?["text"] as? String
        
        // Get images/files for post if any
        if let children = post.childrenPosts, children.count > 0 {
            let placeholder = EkoColorSet.base.blend(.shade4).asImage()
            for eachChild in children {
                
                switch eachChild.dataType {
                case "image":
                    guard let fileId = eachChild.data?["fileId"] as? String else { continue }
                    let tempImage = EkoImage(state: .downloadable(fileId: fileId, placeholder: placeholder))
                    
                    images.append(tempImage)
                    fileMap[fileId] = eachChild.postId
                case "file":
                    if let fileData = eachChild.getFileInfo() {
                        let tempFile = EkoFile(state: .downloadable(fileData: fileData))
                        files.append(tempFile)
                        fileMap[fileData.fileId] = eachChild.postId
                    }
                    
                default:
                    break
                }
            }
        }
    }
    var dataType: DataType {
        let type = DataType(rawValue: post.dataType)
        return type ?? .text
    }
    
    var id: String {
        return post.postId
    }
    
    var parentId: String? {
        return post.parentPostId
    }
    
    var displayName: String {
        return post.postedUser?.displayName ?? EkoLocalizedStringSet.anonymous
    }
    
    var subtitle: String {
        if post.isEdited {
            return "\(post.createdAt.relativeTime) • Edited"
        }
        
        return post.createdAt.relativeTime
    }
    
    var communityDisplayName: String? {
        if let comunity = post.targetCommunity {
            return " ‣ \(comunity.displayName)"
        }
        return nil
    }
    
    var communityId: String? {
        return post.targetCommunity?.communityId
    }
    
    var avatarId: String {
        return post.postedUser?.avatarFileId ?? ""
    }
    
    var postedUserId: String {
        return post.postedUserId
    }
    
    var isAdmin: Bool {
        #warning("incompleted")
        return false
    }
    
    var isOwner: Bool {
        return postedUserId == UpstraUIKitManager.shared.client.currentUserId
    }
    
    var isCommentable: Bool {
        let isCommunityPost = post.targetCommunity != nil
        if isCommunityPost {
            // Community feed requires membership before commenting.
            return post.targetCommunity?.isJoined ?? false
        }
        // All user feeds are commentable.
        return true
    }
    
    var isGroupMember: Bool {
        return post.targetCommunity?.isJoined ?? true
    }
    
    var reactionsCount: Int {
        return Int(post.reactionsCount)
    }
    
    var allCommentCount: Int {
        return Int(post.commentsCount)
    }
    
    var author: EkoUser? {
        return post.postedUser
    }
    
    // Returns post id for file id
    func getPostId(for fileId: String) -> String {
        let postId = fileMap[fileId]
        return postId ?? ""
    }
    
    var isLiked: Bool {
        guard let myReactions = post.myReactions as? [String] else {
            return false
        }
        return myReactions.contains("like")
    }
}
