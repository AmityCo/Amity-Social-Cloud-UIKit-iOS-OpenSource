//
//  EkoComment.h
//  EkoChat
//
//  Created by Michael Abadi Santoso on 5/21/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoEnums.h"
@class EkoUser;

/**
 Comment object
 */
__attribute__((objc_subclassing_restricted))
@interface EkoComment : NSObject
/**
 Uniquely identifies this comment.
 */
@property (nonnull, strong, readonly, nonatomic) NSString *commentId;
/**
 Identifies the parent where this comment has been posted.
 */
@property (nullable, strong, readonly, nonatomic) NSString *parentId;
/**
 The references of this comment.
 */
@property (nonnull, strong, readonly, nonatomic) NSString *referenceId;
/**
 The user id of the owner of the comment.
 */
@property (nonnull, strong, readonly, nonatomic) NSString *userId;
/**
 The reference type.
 */
@property (readonly, nonatomic) EkoCommentReferenceType referenceType;
/**
The data type.
*/
@property (readonly, nonatomic) EkoDataType dataType;
/**
 The comment data.
 */
@property (nullable, strong, readonly, nonatomic) NSDictionary *data;
/**
 The comment metadata.
 */
@property (nullable, strong, readonly, nonatomic) NSDictionary *metadata;
/**
 The reactions data.
 */
@property (nullable, strong, readonly, nonatomic) NSDictionary *reactions;

/**
  The list of my reactions to this post.
*/
@property (nonnull, assign, readonly, nonatomic) NSArray <NSString *> *myReactions;

/**
   Number of people that have flagged this comment
 */
@property (assign, readonly, nonatomic) NSUInteger flagCount;
/**
   Number of children of this comment.
 */
@property (assign, readonly, nonatomic) NSUInteger childrenNumber;
/**
   Number of reaction of this comment.
 */
@property (assign, readonly, nonatomic) NSUInteger reactionsCount;
/**
 The comment creation time.
 */
@property (nonnull, strong, readonly, nonatomic) NSDate *createdAt;
/**
 The last time this comment has been updated.
 */
@property (nonnull, strong, readonly, nonatomic) NSDate *updatedAt;
/**
 The last time this comment has been updated.
 */
@property (nonnull, strong, readonly, nonatomic) NSDate *editedAt;
/**
 Whether the comment has been deleted.
 */
@property (assign, readonly, nonatomic) BOOL isDeleted;
/**
 Whether the comment has been edited.
 */
@property (assign, readonly, nonatomic) BOOL isEdited;

/**
 The sync state of the comment.
 */
@property (readonly, nonatomic) EkoSyncState syncState;
/**
 The comment author.
 */
@property (nullable, strong, readonly, nonatomic) EkoUser *user;

@end
