//
//  EkoPost.h
//  EkoChat
//
//  Created by Michael Abadi Santoso on 4/13/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoEnums.h"
#import "EkoCommunity.h"

@class EkoPost;
@class EkoUser;
@class EkoImageData;
@class EkoFileData;
@class EkoComment;

/**
 * Post
 */
__attribute__((objc_subclassing_restricted))
@interface EkoPost : NSObject

/**
 * The unique identifier for the post
 */
@property (nonnull, strong, readonly, nonatomic) NSString *postId;

/**
 * The unique identifier for the post user id
 */
@property (nonnull, strong, readonly, nonatomic) NSString *postedUserId;

/**
 * The unique identifier for the shared user id
 */
@property (nonnull, strong, readonly, nonatomic) NSString *sharedUserId;

/**
 * The data type of the post
 */
@property (nonnull, strong, readonly, nonatomic) NSString *dataType;

/**
 The post author.
 */
@property (nullable, strong, readonly, nonatomic) EkoUser *postedUser;

/**
 The shared author.
 */
@property (nullable, strong, readonly, nonatomic) EkoUser *sharedUser;

/**
   Number of share on this post
 */
@property (assign, readonly, nonatomic) NSUInteger sharedCount;

/**
 * Post data
 */
@property (nullable, strong, readonly, nonatomic) NSDictionary<NSString *, id> *data;

/**
 * Post meta data
 */
@property (nullable, strong, readonly, nonatomic) NSDictionary<NSString *, id> *metadata;

/**
 * The creation date of the post
 */
@property (nonnull, strong, nonatomic) NSDate *createdAt;

/**
   @abstract The post last edited time
   @discussion The updated time is updated for updated data on the post
 */
@property (nonnull, strong, nonatomic) NSDate *updatedAt;

/**
 Timestamp when this post was last edited by user. For newly created post, `createdAt` & `editedAt` would be the same
 */
@property (nonnull, strong, nonatomic) NSDate *editedAt;

/**
  Number of reaction on this post
*/
@property (assign, nonatomic, readonly) NSUInteger reactionsCount;

/**
  The list of my reactions to this post.
*/
@property (nonnull, assign, readonly, nonatomic) NSArray <NSString *> *myReactions;

/**
 The reaction data.
 */
@property (nullable, strong, readonly, nonatomic) NSDictionary *reactions;

/**
  Number of people that have flagged this post
*/
@property (assign, readonly, nonatomic) NSUInteger flagCount;

/**
 The sync state of the comment.
 */
@property (readonly, nonatomic) EkoSyncState syncState;

/**
 Determines if this post has been edited.
 */
@property (readonly, nonatomic) BOOL isEdited;

/**
 Whether the post has been deleted.
 */
@property (assign, readonly, nonatomic) BOOL isDeleted;

/**
 Id of the parent post
 */
@property (nullable, nonatomic) NSString *parentPostId;

/**
 Total number of comments in this post.
 */
@property (readonly, nonatomic) NSUInteger commentsCount;

/**
 Returns array of children posts.
 */
@property (nullable, nonatomic) NSArray<EkoPost *> *childrenPosts;

/**
 Id of the target this post belongs to.
 */
@property (nonnull, nonatomic) NSString *targetId;

/**
 Id of the target this post belongs to.
 */
@property (nonnull, nonatomic) NSString *targetType;

/**
 The community to which this post belongs to.
 */
@property (nullable, nonatomic) EkoCommunity *targetCommunity;

/**
 Array of latest 5 comments
 */
@property (nonnull, nonatomic) NSArray<EkoComment *> *latestComments;

/**
 Gets the file data associated with this post.
 
 @return: Returns EkoFileData if present. Else returns nil.
 */
- (nullable EkoFileData *)getFileInfo;

/**
 Gets the image data associated with this post.
 
 @return: Returns EkoImageData if present. Else returns nil.
 */
- (nullable EkoImageData *)getImageInfo;

@end
