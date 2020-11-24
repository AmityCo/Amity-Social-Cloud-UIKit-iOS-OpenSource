//
//  EkoMessageReactor.h
//  EkoChat
//
//  Created by Michael Abadi Santoso on 12/26/19.
//  Copyright © 2019 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoClient.h"
#import "EkoCollection.h"
#import "EkoMessage.h"

@class EkoMessage;

/**
   A editor encapsulates methods for managing messages
 */
@interface EkoMessageReactor : NSObject

/**
   The context used to create the instance
 */
@property (nonnull, strong, readonly, nonatomic) EkoClient *client;

/**
   The message Id associated with the instance
 */
@property (nonnull, strong, readonly, nonatomic) EkoMessage *message;

/**
   Designated intializer
   @param client A valid context instance
   @param message A valid message object
 */
- (nonnull instancetype)initWithClient:(nonnull EkoClient *)client
                               message:(nonnull EkoMessage *)message NS_DESIGNATED_INITIALIZER;

/**
   React the message, this is reported to the admin panel for the moderators to see
 */
- (void)addReactionWithReaction:(nonnull NSString *)reaction
                     completion:(EkoRequestCompletion _Nullable)completion;

/**
   Unreact the message
 */
- (void)removeReactionWithReaction:(nonnull NSString *)reaction
                        completion:(EkoRequestCompletion _Nullable)completion;

/// Block call of `init` and `new` because this object cannot be created directly
- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end
