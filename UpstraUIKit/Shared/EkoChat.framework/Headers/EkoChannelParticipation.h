//
//  EkoChannelParticipation.h
//  EkoChat
//
//  Created by eko on 2/13/18.
//  Copyright © 2018 eko. All rights reserved.
//

#import "EkoClient.h"
#import "EkoCollection.h"
#import <Foundation/Foundation.h>

@class EkoChannel;
@class EkoChannelMembership;

typedef NS_OPTIONS(NSUInteger, EkoChannelMembershipFilter) {
    EkoChannelMembershipFilterAll,
    EkoChannelMembershipFilterMute,
    EkoChannelMembershipFilterBan
};

NS_ASSUME_NONNULL_BEGIN

/**
   A membership encapsulates methods for managing users in a channel
 */
@interface EkoChannelParticipation : NSObject

/**
   The client used to create the instance
 */
@property (nonnull, strong, readonly, nonatomic) EkoClient *client;

/**
   The channel Id associated with the instance
 */
@property (nonnull, strong, readonly, nonatomic) NSString *channelId;

/**
   The memberships associated with the channel
 */
@property (nonnull, strong, readonly, nonatomic) EkoCollection<EkoChannelMembership *> *memberships;

/**
   Designated intializer
   @param client A valid client instance
   @param channelId The Id of the channel to update
 */
- (nonnull instancetype)initWithClient:(nonnull EkoClient *)client
                            andChannel:(nonnull NSString *)channelId NS_DESIGNATED_INITIALIZER;

/**
   Leaves the channel for the current user
   @param completion A block executed when the request has completed
 */
- (void)leaveWithCompletion:(EkoRequestCompletion _Nullable)completion;

/**
   Gets the members associated with the instance filtered by the filter parameter

   @param filter A vaild EkoChannelMembershipFilter enum option
 */
- (nonnull EkoCollection<EkoChannelMembership *> *)membershipsForFilter:(EkoChannelMembershipFilter)filter sortBy:(EkoSortBy)sortBy;

/**
   Adds users to the channel

   @param userIds An array of users Ids to add
   @param completion A block executed when the request has completed
 */
- (void)addUsers:(nonnull NSArray<NSString *> *)userIds completion:(EkoRequestCompletion _Nullable)completion;

/**
   Removes users from the channel

   @param userIds An array of users Ids to remove
   @param completion A block executed when the request has completed
 */
- (void)removeUsers:(nonnull NSArray<NSString *> *)userIds completion:(EkoRequestCompletion _Nullable)completion;

/**
   Let the server know that the user is currently viewing this channel (this automatically updates the user's readToSegment)
   A user can read multiple channels at the same time.
 */
- (void)startReading;

/**
   Let the server know that the user has stopped reading this channel (this automatically updates the user's readToSegment)
 */
- (void)stopReading;

/**
   Block call of `init` and `new` because this object cannot be created directly
 **/
- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
