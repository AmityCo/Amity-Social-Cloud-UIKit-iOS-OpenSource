//
//  EkoCommmentFlagger.h
//  EkoChat
//
//  Created by Michael Abadi Santoso on 6/2/20.
//  Copyright © 2020 eko. All rights reserved.
//

@import Foundation;

#import "EkoClient.h"
#import "EkoCollection.h"

@class EkoComment;

/**
   A editor encapsulates methods for managing comment
 */
@interface EkoCommentFlagger : NSObject

/**
   The context used to create the instance
 */
@property (nonnull, strong, readonly, nonatomic) EkoClient *client;

/**
   The comment id associated with the instance
 */
@property (nonnull, strong, readonly, nonatomic) NSString *commentId;

/**
   Designated intializer
   @param client A valid context instance
   @param commenId A valid commmentId of the comment
 */
- (nonnull instancetype)initWithClient:(nonnull EkoClient *)client
                             commentId:(nonnull NSString *)commentId NS_DESIGNATED_INITIALIZER;

/**
   Flags the commment, this is reported to the admin panel for the moderators to see
 */
- (void)flagWithCompletion:(EkoRequestCompletion _Nullable)completion;

/**
   Unflags the comment
 */
- (void)unflagWithCompletion:(EkoRequestCompletion _Nullable)completion;

/**
   The callback returns whether the logged-in user has flagged this comment
 */
- (void)isFlagByMeWithCompletion:(void(^ _Nonnull)(BOOL isFlagByMe))callback;

/// Block call of `init` and `new` because this object cannot be created directly
- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end
