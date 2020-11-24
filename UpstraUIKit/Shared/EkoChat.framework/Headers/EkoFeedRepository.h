//
//  EkoFeedRepository.h
//  EkoChat
//
//  Created by Michael Abadi Santoso on 4/13/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoClient.h"
#import "EkoCollection.h"
#import "EkoBuilder.h"

@class EkoPost;
@class EkoPostReaction;

NS_ASSUME_NONNULL_BEGIN

/**
 * Repository provides access to feed and collections of feeds
 */
@interface EkoFeedRepository : NSObject

@property (strong, readonly, nonatomic) EkoClient *client;

/**
 Designated intializer
 @param client A valid context instance
 */
- (instancetype)initWithClient:(EkoClient *)client NS_DESIGNATED_INITIALIZER;

/**
 Create the which need a text represented by string value
 @param builder: A type of EkoPostBuilder object. You can use EkoTextPostBuilder to create text post.
 @param targetId: Target id for the feed. Set nil if you are creating a post on your own feed.
 @param targetType: Target type for the feed. Either community or user.
 
 */
- (void)createPost:(nonnull id<EkoPostBuilder>)builder
          targetId:(nullable NSString *)targetId
        targetType:(EkoPostTargetType)targetType
        completion:(EkoRequestCompletion _Nullable)completion;

/**
 Update specific post with the updated data
 @param postId: A post id represent the post object
 @param builder: A type of EkoPostBuilder object. You can use EkoTextPostBuilder to create text post. **Note** Builder should be of same type that you used to create the original post.
 */
- (void)updatePostWithPostId:(nonnull NSString *)postId
                     builder:(nonnull id<EkoPostBuilder>)builder
                  completion:(EkoRequestCompletion _Nullable)completion;

/**
 Delete the specific post with provided id
 @param postId: A post id represent the post object
 @param parentId: Id of the parent post. If a post has parent, then provide its id.
 */
- (void)deletePostWithPostId:(nonnull NSString *)postId
                    parentId:(nullable NSString *)parentId
                  completion:(EkoRequestCompletion _Nullable)completion;

/**
 Get the collection of own feed.
 
 @param sortBy The sort option that user wish to select
 @param includeDeleted Whether to include deleted posts in query or not
 @return The EkoCollection of EkoPost  object. Observe the changes for getting the result.
 
 */
- (nonnull EkoCollection<EkoPost *> *)getMyFeedSortedBy:(EkoUserFeedSortOption)sortBy includeDeleted:(BOOL)includeDeletedPosts;

/**
 Get the collection of user feed.
 
 @param userId The user id of selected user
 @param sortBy The sort option that user wish to select
 @param includeDeleted Whether to include deleted posts in query or not
 @return The EkoCollection of EkoPost  object. Observe the changes for getting the result.
 
 */
- (nonnull EkoCollection<EkoPost *> *)getUserFeed:(NSString *)userId sortBy:(EkoUserFeedSortOption)sortBy includeDeleted:(BOOL)includeDeletedPosts;

/**
 Get the collection of global feed.
 
 @param sortBy The sort option that user wish to select
 @param includeDeleted Whether to include deleted posts in query or not
 @return The EkoCollection of EkoPost  object. Observe the changes for getting the result.
 
 */
- (nonnull EkoCollection<EkoPost *> *)getGlobalFeed;

/**
 Retrieves post for particular post id
 
 @param postId The id for the post
 */
- (nonnull EkoObject<EkoPost *> *)getPostForPostId:(nonnull NSString *)postId;

/**
 Get the collection of reactions for particular post for provided reaction name.
 
 @param postId: Id of the post
 @param reactionName: Name of the reaction
 @return EkoCollection of EkoPostReaction object. Observe the changes to get results.
 
 */
- (nonnull EkoCollection<EkoPostReaction *> *)getReactionsForPostWithPostId:(nonnull NSString *)postId reactionName:(NSString *)reactionName;

/**
 Get all  reactions for particular post
 
 @param postId: Id of the post
 @return EkoCollection of EkoPostReaction object. Observe the changes to get results.
 
 */
- (nonnull EkoCollection<EkoPostReaction *> *)getAllReactionsForPostWithPostId:(nonnull NSString *)postId;


/**
 Get the collection of community feed.
 
 @param communityId The community id of selected community
 @param sortBy The sort option that user wish to select
 @param includeDeleted Whether to include deleted posts in query or not
 @return The EkoCollection of EkoPost  object. Observe the changes for getting the result.
 */
- (nonnull EkoCollection<EkoPost *> *)getCommunityFeedWithCommunityId:(nonnull NSString *)communityId
                                                               sortBy:(EkoCommunitySortOption)sortBy
                                                       includeDeleted:(BOOL)includeDeletedPosts;


/**
 Block call of `init` and `new` because this object cannot be created directly
 **/
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
