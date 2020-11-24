//
//  EkoUserFlagger.h
//  EkoChat
//
//  Created by Federico Zanetello on 11/28/18.
//  Copyright © 2018 eko. All rights reserved.
//

@import Foundation;

#import "EkoClient.h"
#import "EkoCollection.h"
#import "EkoUser.h"

@class EkoUser;

/**
   A editor encapsulates methods for managing messages
 */
@interface EkoUserFlagger : NSObject

/**
   The context used to create the instance
 */
@property (nonnull, strong, readonly, nonatomic) EkoClient *client;

/**
   The user Id associated with the instance
 */
@property (nonnull, strong, readonly, nonatomic) EkoUser *user;

/**
   Designated intializer
   @param client A valid context instance
 */
- (nonnull instancetype)initWithClient:(nonnull EkoClient *)client
                                  user:(nonnull EkoUser *)user NS_DESIGNATED_INITIALIZER;

/**
   Flags user, this is reported to the admin panel for the moderators to see
 */
- (void)flagWithCompletion:(EkoRequestCompletion _Nullable)completion;

/**
   Unflags the user
 */
- (void)unflagWithCompletion:(EkoRequestCompletion _Nullable)completion;

/**
   The callback returns whether the logged-in user has flagged this user
 */
- (void)isFlagByMeWithCompletion:(void(^ _Nonnull)(BOOL isFlagByMe))completion;

/// Block call of `init` and `new` because this object cannot be created directly
- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end
