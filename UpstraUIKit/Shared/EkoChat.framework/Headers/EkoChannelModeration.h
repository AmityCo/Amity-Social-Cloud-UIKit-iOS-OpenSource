//
//  EkoChannelModeration.h
//  EkoChat
//
//  Created by eko on 2/16/18.
//  Copyright © 2018 eko. All rights reserved.
//

#import "EkoChannelMembershipPrivileges.h"
#import "EkoClient.h"
#import <Foundation/Foundation.h>

@class EkoChannel;

NS_ASSUME_NONNULL_BEGIN

@interface EkoChannelModeration : NSObject

/**
   Designated intializer.
   @param client A valid client instance.
   @param channelId The Id of the channel to update.
 */
- (nonnull instancetype)initWithClient:(nonnull EkoClient *)client
                            andChannel:(nonnull NSString *)channelId NS_DESIGNATED_INITIALIZER;

/**
   The client used to create the instance
 */
@property (nonnull, strong, readonly, nonatomic) EkoClient *client;
/**
   The channel Id associated with the instance
 */
@property (nonnull, strong, readonly, nonatomic) NSString *channelId;

/**
   Mute users
   @param userIds An array of userIds
   @param mutePeriodInSeconds (in seconds)
   @param completion A block executed when the request has completed
 */
- (void)muteUsers:(nonnull NSArray<NSString *> *)userIds
       mutePeriod:(NSUInteger)mutePeriodInSeconds
       completion:(EkoRequestCompletion _Nullable)completion;

/**
   unmute users
   @param userIds An array of userIds
   @param completion A block executed when the request has completed
 */
- (void)unmuteUsers:(nonnull NSArray<NSString *> *)userIds
         completion:(EkoRequestCompletion _Nullable)completion;

/**
 *
 * @param rateLimitPeriodInSeconds (in seconds)
 * @param rateLimit the rate limit
 * @param rateLimitWindowInSeconds (in seconds)
 * @param completion A block executed when the request has completed
 */
- (void)rateLimitPeriod:(NSUInteger)rateLimitPeriodInSeconds
              rateLimit:(NSUInteger)rateLimit
        rateLimitWindow:(NSUInteger)rateLimitWindowInSeconds
             completion:(EkoRequestCompletion _Nullable)completion;

/**
   Frees the channel from any rate limit previously set
   @param completion A block executed when the request has completed
 */
- (void)removeRateLimitWithCompletion:(EkoRequestCompletion _Nullable)completion;

/**
   Ban users
   @param userIds An array of userIds
   @param completion A block executed when the request has completed
 */
- (void)banUsers:(NSArray<NSString *> *)userIds
      completion:(EkoRequestCompletion _Nullable)completion;

/**
   unban users
   @param userIds An array of userIds
   @param completion A block executed when the request has completed
 */
- (void)unbanUsers:(NSArray<NSString *> *)userIds
        completion:(EkoRequestCompletion _Nullable)completion;

/**
   add role
   @param role A role
   @param userIds The userIds whose role must be added
   @param completion A block executed when the request has completed
 */
- (void)addRole:(nonnull NSString *)role
        userIds:(nonnull NSArray <NSString *> *)userIds
     completion:(EkoRequestCompletion _Nullable)completion;

/**
   remove role
   @param role A role
   @param userIds The userIds whose role must be removed
   @param completion A block executed when the request has completed
 */
- (void)removeRole:(nonnull NSString *)role
           userIds:(nonnull NSArray <NSString *> *)userIds
        completion:(EkoRequestCompletion _Nullable)completion;

/**
   The privileges of the user in the current channel
 */
- (EkoObject<EkoChannelMembershipPrivileges *> *)privileges;

/**
   Block call of `init` and `new` because this object cannot be created directly
 **/
- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
