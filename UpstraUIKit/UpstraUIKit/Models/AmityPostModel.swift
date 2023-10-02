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
    
    public class Poll {
        
        // Public
        public let id: String
        public let question: String
        public let answers: [Answer]
        public let isMultipleVoted: Bool
        public let status: String
        public let isClosed: Bool
        public let isVoted: Bool
        public let closedIn: UInt64 // This time is in milliseconds.
        public let voteCount: Int
        public let createdAt: Date
        
        public init(poll: AmityPoll) {
            self.id = poll.pollId
            self.question = poll.question
            self.isMultipleVoted = poll.isMultipleVote
            self.status = poll.status
            self.isClosed = poll.isClosed
            self.isVoted = poll.isVoted
            self.closedIn = UInt64(poll.closedIn)
            self.voteCount = Int(poll.voteCount)
            self.answers = poll.answers.map { Answer(answer: $0) }
            self.createdAt = poll.createdAt
        }
        
        public class Answer {
            public let id: String
            public let dataType: String
            public let text: String
            public let isVotedByUser: Bool
            public let voteCount: Int
            var isSelected: Bool = false
            
            public init(answer: AmityPollAnswer) {
                self.id = answer.answerId
                self.dataType = answer.dataType
                self.text = answer.text
                self.isVotedByUser = answer.isVotedByUser
                self.voteCount = Int(answer.voteCount)
            }
        }
    }

}

extension AmityPostModel {
    
    public enum PostDisplayType {
        case feed
        case postDetail
    }
    
    public class Author {
        public let avatarURL: String?
        public let displayName: String?
        public let isGlobalBan: Bool
        
        public init( avatarURL: String?, displayName: String?, isGlobalBan: Bool) {
            self.avatarURL = avatarURL
            self.displayName = displayName
            self.isGlobalBan = isGlobalBan
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
        case video
        case poll
        case liveStream
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
    
    /// List of all reactions in this post with count.
    public let reactions: [String: Int]
    
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
     * The post metadata
     */
    public let metadata: [String: Any]?
    
    /**
     * The post mentionees
     */
    public let mentionees: [AmityMentionees]?
    
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
        return postedUser?.displayName ?? AmityLocalizedStringSet.General.anonymous.localizedString
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
    
    public var poll: Poll?
    
    var commentExpandedIds: Set<String> = []
    
    // MARK: - Internal variables
    
    var dataTypeInternal: DataType = .unknown
    var isModerator: Bool = false
    let parentPostId: String?
    let latestComments: [AmityCommentModel]
    let postAsModerator: Bool = false
    private(set) var text: String = ""
    private(set) var medias: [AmityMedia] = []
    private(set) var files: [AmityFile] = []
    private(set) var liveStream: AmityStream?
    private let post: AmityPost
    private let childrenPosts: [AmityPost]
    
    // Maps fileId to PostId for child post
    private var fileMap = [String: String]()
    
    var isLiked: Bool {
        return myReactions.contains(.like)
    }
    
    private(set) var feedType: AmityFeedType = .published
    
    // MARK: - Initializer
    
    public init(post: AmityPost) {
        self.post = post
        postId = post.postId
        latestComments = post.latestComments.map(AmityCommentModel.init)
        dataType = post.dataType
        targetId = post.targetId
        targetCommunity = post.targetCommunity
        childrenPosts = post.childrenPosts
        parentPostId = post.parentPostId
        postedUser = Author(
            avatarURL: post.postedUser?.getAvatarInfo()?.fileURL,
            displayName: post.postedUser?.displayName ?? AmityLocalizedStringSet.General.anonymous.localizedString, isGlobalBan: post.postedUser?.isGlobalBanned ?? false)
        subtitle = post.isEdited ? String.localizedStringWithFormat(AmityLocalizedStringSet.PostDetail.postDetailCommentEdit.localizedString, post.createdAt.relativeTime) : post.createdAt.relativeTime
        postedUserId = post.postedUserId
        sharedCount = Int(post.sharedCount)
        reactionsCount = Int(post.reactionsCount)
        reactions = post.reactions as? [String: Int] ?? [:]
        allCommentCount = Int(post.commentsCount)
        allReactions = post.myReactions
        myReactions = allReactions.compactMap(AmityReactionType.init)
        feedType = post.getFeedType()
        data = post.data ?? [:]
        appearance = AmityPostAppearance()
        poll = post.getPollInfo().map(Poll.init)
        metadata = post.metadata
        mentionees = post.mentionees
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
    func getPostId(forFileId fileId: String) -> String? {
        guard let postId = fileMap[fileId] else {
            assertionFailure("A fileId must exist")
            return nil
        }
        return postId
    }
    
    // Each post has a property called childrenPosts. This contains an array of AmityPost object.
    // If a post contains files or images, those are present as children posts. So we need
    // to go through that array to determine the post type.
    private func extractPostData() {
        
        text = data[DataType.text.rawValue] as? String ?? ""
        dataTypeInternal = DataType(rawValue: dataType) ?? .unknown
        
        // Get images/files for post if any
        
        for aChild in childrenPosts {
            switch aChild.dataType {
            case "image":
                let placeholder = AmityColorSet.base.blend(.shade4).asImage()
                if let imageData = aChild.getImageInfo() {
                    let state = AmityMediaState.downloadableImage(
                        imageData: imageData,
                        placeholder: placeholder
                    )
                    let media = AmityMedia(state: state, type: .image)
                    media.image = imageData
                    medias.append(media)
                    fileMap[imageData.fileId] = aChild.postId
                    dataTypeInternal = .image
                }
            case "file":
                if let fileData = aChild.getFileInfo() {
                    let tempFile = AmityFile(state: .downloadable(fileData: fileData))
                    files.append(tempFile)
                    fileMap[fileData.fileId] = aChild.postId
                    dataTypeInternal = .file
                }
            case "video":
                if let videoData = aChild.getVideoInfo() {
                    let thumbnail = aChild.getVideoThumbnailInfo()
                    let state = AmityMediaState.downloadableVideo(
                        videoData: videoData,
                        thumbnailUrl: thumbnail?.fileURL
                    )
                    let media = AmityMedia(state: state, type: .video)
                    media.video = videoData
                    medias.append(media)
                    fileMap[videoData.fileId] = aChild.postId
                    dataTypeInternal = .video
                }
            case "poll":
                dataTypeInternal = .poll
            case "liveStream":
                if let liveStreamData = aChild.getLiveStreamInfo() {
                    liveStream = liveStreamData
                    dataTypeInternal = .liveStream
                }
            default:
                dataTypeInternal = .unknown
            }
        }
    }
    
}
