//
//  EkoCommunityModeration.h
//  EkoChat
//
//  Created by Michael Abadi on 31/08/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import "EkoClient.h"
#import <Foundation/Foundation.h>
@class EkoCommunity;

NS_ASSUME_NONNULL_BEGIN

/**
   A community moderator object
 */

@interface EkoCommunityModeration : NSObject

/**
   Designated intializer.
   @param client A valid client instance.
   @param communityId The Id of the channel to update.
 */
- (nonnull instancetype)initWithClient:(nonnull EkoClient *)client
                          andCommunity:(nonnull NSString *)communityId NS_DESIGNATED_INITIALIZER;

/**
   The client used to create the instance
 */
@property (nonnull, strong, readonly, nonatomic) EkoClient *client;
/**
   The community Id associated with the instance
 */
@property (nonnull, strong, readonly, nonatomic) NSString *communityId;

/**
   Ban users
   @param userIds An array of userIds
   @param completion A block executed when the request has completed
 */
- (void)banUsers:(nonnull NSArray<NSString *> *)userIds
      completion:(EkoRequestCompletion _Nullable)completion;

/**
   unban users
   @param userIds An array of userIds
   @param completion A block executed when the request has completed
 */
- (void)unbanUsers:(nonnull NSArray<NSString *> *)userIds
        completion:(EkoRequestCompletion _Nullable)completion;

/**
   Block call of `init` and `new` because this object cannot be created directly
 */
- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
