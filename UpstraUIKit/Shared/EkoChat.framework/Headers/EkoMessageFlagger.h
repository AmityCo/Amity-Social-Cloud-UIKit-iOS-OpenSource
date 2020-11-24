//
//  EkoMessageFlagger.h
//  EkoChat
//
//  Created by Federico Zanetello on 11/28/18.
//  Copyright © 2018 eko. All rights reserved.
//

@import Foundation;

#import "EkoClient.h"
#import "EkoCollection.h"
#import "EkoMessage.h"

@class EkoMessage;

/**
   A editor encapsulates methods for managing messages
 */
@interface EkoMessageFlagger : NSObject

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
   Flags the message, this is reported to the admin panel for the moderators to see
 */
- (void)flagWithCompletion:(EkoRequestCompletion _Nullable)completion;

/**
   Unflags the message
 */
- (void)unflagWithCompletion:(EkoRequestCompletion _Nullable)completion;

/**
   The callback returns whether the logged-in user has flagged this message
 */
- (void)isFlagByMeWithCompletion:(void(^ _Nonnull)(BOOL isFlagByMe))callback;

/// Block call of `init` and `new` because this object cannot be created directly
- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end
