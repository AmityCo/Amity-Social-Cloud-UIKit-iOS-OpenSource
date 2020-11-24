//
//  EkoCommentRepository.h
//  EkoChat
//
//  Created by Michael Abadi Santoso on 5/20/20.
//  Copyright © 2020 eko. All rights reserved.
//

@import Foundation;
#import "EkoEnums.h"
#import "EkoObject.h"
#import "EkoCollection.h"

@class EkoComment;
@class EkoClient;

/**
 Repository provides access messages and collections.
 */
@interface EkoCommentRepository : NSObject

/**
 The context used to create the instance.
 */
@property (nonnull, strong, readonly, nonatomic) EkoClient *client;

/**
 Designated intializer.
 
 @param client A valid context instance.
 */
- (nonnull instancetype)initWithClient:(nonnull EkoClient *)client NS_DESIGNATED_INITIALIZER;

/**
 Creates a new comment. Comments are created locally and then synced with server. You can observe
 the `syncState` property of `EkoComment` to determine if server sync was successful or not.
 
 @param referenceId: The unique identifiers of id.
 @param referenceType: ReferenceType for comment
 @param parentId: The unique identifiers of the parent of the comment.
 @param text: The comment text.
 @return The EkoComment live object.
 */
- (nonnull EkoObject<EkoComment *> *)createCommentWithReferenceId:(nonnull NSString *)referenceId
                                                    referenceType:(EkoCommentReferenceType)type
                                                         parentId:(nullable NSString *)parentId
                                                             text:(nonnull NSString *)text;
/**
 @abstract Fetches collection of comments for particular post/content.
 
 @discussion:
 You can also fetch comment thread. i.e all the comments under particular comment.
 To do that set `filterByParentId` to true and pass the parent comment id in
 `parentId`. If `filterByParentId` is true but no `parentId` is present,then the
 collection will return all comments without a parent.
 
 @remarks:
 When `orderBy` is set to:
 
 - `.ascending`, we will fetch the first (oldest) comments
 in chronological order: ABC first, then the next page etc.
 
 - `.descending`, we will fetch the last (newest) comments
 in reverse-chronological order: ZYX first, then the previous page etc.
 
 It's up to the developer to call the right `loadNext`/`loadPrevious` page in
 the returned collection based on the `orderBy` value:
 
 @note when asking for more comments, based on the orderBy preference,
 you'll need to ask for the next page (if the order is `.ascending`) or the
 previous page (if the reverse is `.descending`).
 
 @param referenceId: The id of the post/content that you want to fetch comment for.
 @param filterByParentId: Set this to true if you want to fetch comment thread
 @param parentId: The id of the parent comment.
 @param queryOption: Enum to fetch only deleted comments, not deleted comments or both.
 @param orderBy: Whether we'd like the collection in chronological order or not.
 @param includeDeleted: Boolean whether this collection should fetch comments along with deleted comments
 @return The messages collection.
 */
- (nonnull EkoCollection<EkoComment *> *)commentsWithReferenceId:(nonnull NSString *)referenceId
                                                   referenceType:(EkoCommentReferenceType)type
                                                filterByParentId:(BOOL)filterByParentId
                                                        parentId:(nullable NSString *)parentId
                                                         orderBy:(EkoOrderBy)orderOption
                                                  includeDeleted:(BOOL)includeDeletedComments;

/// Block call of `init` and `new` because this object cannot be created directly
- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end
