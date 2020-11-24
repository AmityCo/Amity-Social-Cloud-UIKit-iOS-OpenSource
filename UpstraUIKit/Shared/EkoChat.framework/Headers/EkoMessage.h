//
//  EkoMessageModel.h
//  EkoMessage
//
//  Created by eko on 1/18/18.
//  Copyright © 2018 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoEnums.h"

@class EkoMessage;
@class EkoUser;
@class EkoMessageEditor;

/**
 Message Type

 - EkoMessageTypeText: A text message.
 - EkoMessageTypeImage: An image message.
 - EkoMessageTypeFile: A file message.
 - EkoMessageTypeCustom: A custom message.
 */
typedef NS_ENUM(NSInteger, EkoMessageType) {
    EkoMessageTypeText,
    EkoMessageTypeImage,
    EkoMessageTypeFile,
    EkoMessageTypeCustom
};

/**
 Media Size
 */
typedef NS_ENUM(NSInteger, EkoMediaSize) {
    /// Up to 160 pixels per dimension.
    EkoMediaSizeSmall,
    /// Up to 600 pixels per dimension.
    EkoMediaSizeMedium,
    /// Up to 1500 pixels per dimension.
    EkoMediaSizeLarge,
    /// Original upload resolution (or same as EkoMediaSizeLarge if image was not uploaded with fullImage set to YES).
    EkoMediaSizeFull
};

/**
 Message object
 */
__attribute__((objc_subclassing_restricted))
@interface EkoMessage : NSObject
/**
 Uniquely identifies this message.
 */
@property (nonnull, strong, readonly, nonatomic) NSString *messageId;
/**
 Identifies the channel where this message has been posted.
 */
@property (nonnull, strong, readonly, nonatomic) NSString *channelId;
/**
 The message author `userId`.
 */
@property (nonnull, strong, readonly, nonatomic) NSString *userId;
/**
 The message author.
 */
@property (nullable, strong, readonly, nonatomic) EkoUser *user;
/**
 The message data.
 */
@property (nullable, strong, readonly, nonatomic) NSDictionary *data;
/**
 The reaction data.
 */
@property (nullable, strong, readonly, nonatomic) NSDictionary *reactions;
/**
 The message type.
 */
@property (readonly, nonatomic) EkoMessageType messageType;
/**
 Whether the message has been deleted.
 */
@property (assign, readonly, nonatomic) BOOL isDeleted;
/**
 Whether the message has been edited. If editedAt > createdAt, this value is true.
 */
@property (assign, readonly, nonatomic) BOOL isEdited;


@property (assign, readonly, nonatomic) BOOL isMessageEdited;
/**
 The sync state of the message.
 */
@property (readonly, nonatomic) EkoSyncState syncState;
/**
   Number of people that have flagged this message
 */
@property (assign, readonly, nonatomic) NSUInteger flagCount;
/**
   Number of reaction on this message
 */
@property (assign, readonly, nonatomic) NSUInteger reactionsCount;
/**
   Number of people that have read this message
 */
@property (assign, readonly, nonatomic) NSUInteger readByCount;
/**
 The message creation time.
 */
@property (nonnull, strong, readonly, nonatomic) NSDate *createdAtDate;
/**
 The last time this message has been updated.
 */
@property (nonnull, strong, readonly, nonatomic) NSDate *editedAtDate;
/**
   The message tags.
 */
@property (nonnull, assign, readonly, nonatomic) NSArray <NSString *> *tags;
/**
   The list of my reactions to this message.
 */
@property (nonnull, assign, readonly, nonatomic) NSArray <NSString *> *myReactions;
/**
 The messageId of the parent message.
 */
@property (nullable, nonatomic) NSString *parentId;
/**
 The number of children of this message.
 */
@property (assign, nonatomic) NSUInteger childrenNumber;

@end
