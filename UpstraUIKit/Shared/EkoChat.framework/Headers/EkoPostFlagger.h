//
//  EkoPostFlagger.h
//  EkoChat
//
//  Created by Nishan Niraula on 6/23/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoClient.h"
#import "EkoPost.h"

NS_ASSUME_NONNULL_BEGIN

@class EkoPost;

@interface EkoPostFlagger : NSObject

/**
   The context used to create the instance
 */
@property (nonnull, strong, readonly, nonatomic) EkoClient *client;

/**
   The post id associated with the instance
 */
@property (nonnull, strong, readonly, nonatomic) NSString *postId;


/**
   Designated intializer
   @param client A valid context instance
   @param postId:  ID for the post
 */
- (nonnull instancetype)initWithClient:(nonnull EkoClient *)client
                               postId:(nonnull NSString *)postId NS_DESIGNATED_INITIALIZER;

/**
 Flags the post
 */
- (void)flagPostWithCompletion:(EkoRequestCompletion _Nullable)completion;


/**
   Unflags the post
 */
- (void)unflagPostWithCompletion:(EkoRequestCompletion _Nullable)completion;

/**
 This method checks whether this particular post is flagged by you or not. If its not flagged, the completion handler
 is executed immediately.
 */
- (void)isPostFlaggedByMeWithCompletion:(void(^ _Nonnull)(BOOL isFlaggedByMe))completion;


/// Block call of `init` and `new` because this object cannot be created directly
- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
