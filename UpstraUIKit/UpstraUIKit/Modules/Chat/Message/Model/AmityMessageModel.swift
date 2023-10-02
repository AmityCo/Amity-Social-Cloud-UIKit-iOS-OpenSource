//
//  AmityMessageModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 17/8/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit
import AmitySDK

public final class AmityMessageModel {
    
    public var object: AmityMessage
    public var messageId: String
    public var userId: String
    public var displayName: String?
    public var syncState: AmitySyncState
    public var isDeleted: Bool
    public var isEdited: Bool
    public var flagCount: UInt
    public var messageType: AmityMessageType
    public var createdAtDate: Date
    public var date: String
    public var time: String
    public var data: [AnyHashable : Any]?
    public var tags: [String]
    public var channelSegment: UInt
    
    /**
     * The post appearance settings
     */
    public var appearance: AmityMessageModelAppearance
    
    public var isOwner: Bool {
        return userId == AmityUIKitManagerInternal.shared.client.currentUserId
    }
    
    public init(object: AmityMessage) {
        self.object = object
        self.messageId = object.messageId
        self.userId = object.userId
        self.displayName = object.user?.displayName ?? AmityLocalizedStringSet.General.anonymous.localizedString
        self.syncState = object.syncState
        self.isDeleted = object.isDeleted
        self.isEdited = object.isEdited
        self.messageType = object.messageType
        self.createdAtDate = object.createdAt
        self.date = AmityDateFormatter.Message.getDate(date: self.isEdited ? object.editedAt : object.createdAt)
        self.time = AmityDateFormatter.Message.getTime(date: self.isEdited ? object.editedAt : object.createdAt)
        self.flagCount = UInt(object.flagCount)
        self.data = object.data
        self.tags = object.tags
        self.channelSegment = UInt(object.channelSegment)
        self.appearance = AmityMessageModelAppearance()
    }
    
    public var text: String? {
        return data?["text"] as? String
    }
}

extension AmityMessageModel {
    
    // MARK: - Appearance
    
    open class AmityMessageModelAppearance {
        
        public init () { }
        /**
         * The flag marking a message for how it will display
         *  - true : display a full content
         *  - false : display a partial content with read more button
         */
        public var isExpanding: Bool = false
    }
    
}

extension AmityMessageModel: Hashable {
    
    public static func == (lhs: AmityMessageModel, rhs: AmityMessageModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
        hasher.combine(userId)
        hasher.combine(displayName)
        hasher.combine(syncState)
        hasher.combine(isDeleted)
        hasher.combine(isEdited)
        hasher.combine(flagCount)
        hasher.combine(messageType)
        hasher.combine(createdAtDate)
        hasher.combine(date)
        hasher.combine(time)
        hasher.combine(text)
        hasher.combine(tags)
        hasher.combine(channelSegment)
        if let dataDesc = data?.description {
            hasher.combine(dataDesc)
        }
    }
    
}
