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
    public enum PostDisplayType {
        case feed
        case postDetail
    }
    
    enum DataType: String {
        case text = "text"
        case image = "image"
        case file = "file"
        case unknown
    }
    
    private(set) var post: EkoPost
    
    var text: String?
    var images: [EkoImage] = []
    var files: [EkoFile] = []
    var latestComments: [EkoCommentModel] = []
    var isModerator: Bool = false
    let postAsModerator: Bool = false
    // Maps fileId to PostId for child post
    private var fileMap = [String: String]()
    
    public init(post: EkoPost) {
        self.post = post
        self.extractPostInfo()
        self.latestComments = post.latestComments.map(EkoCommentModel.init)
    }
    
    public var maximumLastestComments: Int {
        return min(2, latestComments.count)
    }
    
    public var viewAllCommentSection: Int {
        return latestComments.count > 2 ? 1 : 0
    }
    
    // Comment will show below last component
    public func getComment(at indexPath: IndexPath, totalComponent index: Int) -> EkoCommentModel? {
        let comments = Array(latestComments.suffix(maximumLastestComments).reversed())
        return comments.count > 0 ? comments[indexPath.row - index] : nil
    }
    
    // Each post has a property called childrenPosts. This contains an array of EkoPost object.
    // If a post contains files or images, those are present as children posts. So we need
    // to go through that array to determine the post type.
    func extractPostInfo() {
        
        dataTypeInternal = DataType(rawValue: post.dataType) ?? .unknown
        // Get Text
        text = post.data?[DataType.text.rawValue] as? String
        
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
                    dataTypeInternal = .image
                case "file":
                    if let fileData = eachChild.getFileInfo() {
                        let tempFile = EkoFile(state: .downloadable(fileData: fileData))
                        files.append(tempFile)
                        fileMap[fileData.fileId] = eachChild.postId
                        dataTypeInternal = .file
                    }
                default:
                    dataTypeInternal = .unknown
                }
            }
        }
    }
    
    // MARK: - Public parameters for client
    /**
     * The data type of the post
     */
    public var dataType: String {
        return post.dataType
    }
    
    /**
     * The custom data of the post
     */
    public var data: [String: Any]? {
        return post.data
    }
    
    /**
     * The post user data of the post
     */
    public var postUser: EkoUser? {
        return post.postedUser
    }
    
    /**
     * Id of the target this post belongs to.
     */
    public var targetId: String {
        return post.targetId
    }
    
    /**
     * The displayType of view `Feed/PostDetail`
     */
    public var displayType: PostDisplayType = .feed
    
    var dataTypeInternal: DataType = .unknown
    
    var id: String {
        return post.postId
    }
    
    var parentId: String? {
        return post.parentPostId
    }
    
    var displayName: String {
        return post.postedUser?.displayName ?? EkoLocalizedStringSet.anonymous.localizedString
    }
    
    var subtitle: String {
        if post.isEdited {
            return String.localizedStringWithFormat(EkoLocalizedStringSet.PostDetail.postDetailCommentEdit.localizedString, post.createdAt.relativeTime)
        }
        
        return post.createdAt.relativeTime
    }
    
    var communityDisplayName: String? {
        return post.targetCommunity?.displayName
    }
    
    var communityId: String? {
        return post.targetCommunity?.communityId
    }
    
    var isOfficialCommunity: Bool {
        return post.targetCommunity?.isOfficial ?? false
    }
    
    var avatarId: String {
        return post.postedUser?.avatarFileId ?? ""
    }
    
    var postedUserId: String {
        return post.postedUserId
    }
    
    var isOwner: Bool {
        return postedUserId == UpstraUIKitManagerInternal.shared.client.currentUserId
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
    
    var sharedCount: Int {
        return Int(post.sharedCount)
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
    
    var postTargetType: EkoPostTargetType {
        return post.targetCommunity == nil ? .user : .community
    }
    
    // Displaying logic
    
    // The flag marking a post for how it will display
    //   - true : display a full content
    //   - false : display a partial content with read more button
    var isExpanding: Bool = false
    
    var shouldContentExpand: Bool {
        switch displayType {
        case .feed:
            return isExpanding
        case .postDetail:
            return true
        }
    }
    
    var shouldShowOption: Bool {
        switch displayType {
        case .feed:
            return true
        case .postDetail:
            return false
        }
    }
    
}
