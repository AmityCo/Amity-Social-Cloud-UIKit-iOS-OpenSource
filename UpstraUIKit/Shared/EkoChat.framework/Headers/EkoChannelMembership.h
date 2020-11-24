//
//  EkoChannelMembership.h
//  EkoChat
//
//  Created by eko on 2/23/18.
//  Copyright © 2018 eko. All rights reserved.
//

#import "EkoEnums.h"
#import "EkoObject.h"
#import "EkoUser.h"
@import Foundation;

@interface EkoChannelMembership : NSObject

/**
   The channelId
 */
@property (nonnull, strong, readonly, nonatomic) NSString *channelId;

/**
   The userId
 */
@property (nonnull, strong, readonly, nonatomic) NSString *userId;

/**
   The user live object (convenience property)
 */
@property (nullable, readonly, nonatomic) EkoObject<EkoUser *> *user;

/**
   The user membership status
 */
@property (readonly) EkoChannelMembershipType membership;

/**
   Banned status
 */
@property (assign, readonly, nonatomic) BOOL isBanned;

/**
   Muted status
 */
@property (assign, readonly, nonatomic) BOOL isMuted;

/**
   Roles
 */
@property (nullable, assign, readonly, nonatomic) NSArray <NSString *> *roles;

@end
