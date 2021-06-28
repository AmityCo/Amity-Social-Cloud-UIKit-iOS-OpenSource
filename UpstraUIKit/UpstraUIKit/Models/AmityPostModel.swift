//
//  AmityPostModel.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 20/7/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import AmitySDK
import UIKit

extension AmityPostModel {
    
    public enum PostDisplayType {
        case feed
        case postDetail
    }
    
    public class Author {
        public let avatarURL: String?
        public let displayName: String?
        
        public init( avatarURL: String?, displayName: String?) {
            self.avatarURL = avatarURL
            self.displayName = displayName
        }
    }
    
    open class AmityPostAppearance {
        
        public init () { }
        
        /**
         * The displayType of view `Feed/PostDetail`
         */
        public var displayType: PostDisplayType = .feed
        
        /**
         * The flag for showing comunity name
         */
        public var shouldShowCommunityName: Bool = true
        
        /**
         * The flag marking a post for how it will display
         *  - true : display a full content
         *  - false : display a partial content with read more button
         */
        public var isExpanding: Bool = false
        
        /**
         * The flag for handling content expansion state
         */
        public var shouldContentExpand: Bool {
            switch displayType {
            case .feed:
                return isExpanding
            case .postDetail:
                return true
            }
        }
        
        /**
         * The flag for showing option
         */
        public var shouldShowOption: Bool {
            switch displayType {
            case .feed:
                return true
            case .postDetail:
                return false
            }
        }
    }
    
}

public class AmityPostModel {
    
    enum DataType: String {
        case text
        case image
        case file
        case unknown
    }
    
    // MARK: - Public variables
    
    /**
     * The unique identifier for the post
     */
    public let postId: String
    
    /**
     * The unique identifier for the post user id
     */
    public let postedUserId: String
    
    /**
     * The data type of the post
     */
    public let dataType: String
    
    /**
     * The reactions of the post
     */
    public let myReactions: [AmityReactionType]
    
    /**
     * All reactions of the post includes unsupported types
     */
    public let allReactions: [String]
    
    /**
     * Id of the target this post belongs to.
     */
    public let targetId: String
    
    /**
     * The custom data of the post
     */
    public let data: [String: Any]
    
    /**
     * The post target community
     */
    public let targetCommunity: AmityCommunity?
    
    /**
     * The post target type
     */
    public var postTargetType: AmityPostTargetType {
        return targetCommunity == nil ? .user : .community
    }
    
    /**
     * The post is owner flag
     */
    public var isOwner: Bool {
        return postedUserId == AmityUIKitManagerInternal.shared.client.currentUserId
    }
    
    /**
     * The post commentable flag
     */
    public var isCommentable: Bool {
        if let targetCommunity = self.targetCommunity {
            // Community feed requires membership before commenting.
            return targetCommunity.isJoined
        }
        // All user feeds are commentable.
        return true
    }
    
    /**
     * The post is group member flag
     */
    public var isGroupMember: Bool {
        return targetCommunity?.isJoined ?? false
    }
    
    /**
     * The post user data of the post
     */
    public var postedUser: AmityPostModel.Author?
    
    /**
     * Posted user display name
     */
    public var displayName: String {
        return postedUser?.displayName ?? AmityLocalizedStringSet.anonymous.localizedString
    }
    
    /**
     * A subtitle of post
     */
    public let subtitle: String
    
    /**
     * A reaction count of post
     */
    public let reactionsCount: Int
    
    /**
     * A comment count of post
     */
    public let allCommentCount: Int
    
    /**
     * A share count of post
     */
    public let sharedCount: Int
    
    /**
     * The post appearance settings
     */
    public var appearance: AmityPostAppearance
    
    // MARK: - Internal variables
    
    var dataTypeInternal: DataType = .unknown
    var isModerator: Bool = false
    let parentPostId: String?
    let latestComments: [AmityCommentModel]
    let postAsModerator: Bool = false
    private(set) var text: String = ""
    private(set) var images: [AmityImage] = []
    private(set) var files: [AmityFile] = []
    private let childrenPosts: [AmityPost]
    
    // Maps fileId to PostId for child post
    private var fileMap = [String: String]()
    
    var isLiked: Bool {
        return myReactions.contains(.like)
    }
    
    // MARK: - Initializer
    
    public init(post: AmityPost) {
        postId = post.postId
        latestComments = post.latestComments.map(AmityCommentModel.init)
        dataType = post.dataType
        targetId = post.targetId
        targetCommunity = post.targetCommunity
        childrenPosts = post.childrenPosts ?? []
        parentPostId = post.parentPostId
        postedUser = Author(
            avatarURL: post.postedUser?.getAvatarInfo()?.fileURL,
            displayName: post.postedUser?.displayName ?? AmityLocalizedStringSet.anonymous.localizedString)
        subtitle = post.isEdited ? String.localizedStringWithFormat(AmityLocalizedStringSet.PostDetail.postDetailCommentEdit.localizedString, post.createdAt.relativeTime) : post.createdAt.relativeTime
        postedUserId = post.postedUserId
        sharedCount = Int(post.sharedCount)
        reactionsCount = Int(post.reactionsCount)
        allCommentCount = Int(post.commentsCount)
        allReactions = post.myReactions as? [String] ?? []
        myReactions = allReactions.compactMap(AmityReactionType.init)
        data = post.data ?? [:]
        appearance = AmityPostAppearance()
        extractPostData()
    }
    
    // MARK: - Helper methods
    
    public var maximumLastestComments: Int {
        return min(2, latestComments.count)
    }
    
    public var viewAllCommentSection: Int {
        return latestComments.count > 2 ? 1 : 0
    }
    
    // Comment will show below last component
    public func getComment(at indexPath: IndexPath, totalComponent index: Int) -> AmityCommentModel? {
        let comments = Array(latestComments.suffix(maximumLastestComments).reversed())
        return comments.count > 0 ? comments[indexPath.row - index] : nil
    }
    
    // Returns post id for file id
    func getPostId(for fileId: String) -> String {
        let postId = fileMap[fileId]
        return postId ?? ""
    }
    
    // Each post has a property called childrenPosts. This contains an array of AmityPost object.
    // If a post contains files or images, those are present as children posts. So we need
    // to go through that array to determine the post type.
    private func extractPostData() {
        
        text = data[DataType.text.rawValue] as? String ?? ""
        dataTypeInternal = DataType(rawValue: dataType) ?? .unknown
        
        // Get images/files for post if any
        
        for eachChild in childrenPosts {
            switch eachChild.dataType {
            case "image":
                let placeholder = AmityColorSet.base.blend(.shade4).asImage()
                let imageInfo = eachChild.getImageInfo()
                guard let imageURL = imageInfo?.fileURL, let imageId = imageInfo?.fileId else { continue }
                let tempImage = AmityImage(state: .downloadable(fileURL: imageURL, placeholder: placeholder))

                images.append(tempImage)
                fileMap[imageId] = eachChild.postId
                dataTypeInternal = .image
            case "file":
                if let fileData = eachChild.getFileInfo() {
                    let tempFile = AmityFile(state: .downloadable(fileData: fileData))
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
