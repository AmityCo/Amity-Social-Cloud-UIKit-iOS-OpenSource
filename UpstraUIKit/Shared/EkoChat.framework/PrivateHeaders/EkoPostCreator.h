//
//  EkoPostCreator.h
//  EkoChat
//
//  Created by Michael Abadi Santoso on 4/21/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoClient.h"
#import "UIKit/UIKit.h"
#import "EkoBuilder.h"

@class EkoPost;

/**
 A editor encapsulates methods for managing post
 */
@interface EkoPostCreator : NSObject

/**
 The context used to create the instance
 */
@property (nonnull, strong, readonly, nonatomic) EkoClient *client;

/**
 Designated intializer
 @param client: A valid client instance
 */
- (nonnull instancetype)initWithClient:(nonnull EkoClient *)client NS_DESIGNATED_INITIALIZER;

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

/// Block call of `init` and `new` because this object cannot be created directly
- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end
