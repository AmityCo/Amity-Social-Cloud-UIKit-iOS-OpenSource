//
//  EkoConversationChannelBuilder.h
//  EkoChat
//
//  Created by Nishan Niraula on 8/19/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoBuilder.h"
#import "EkoImageData.h"

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_subclassing_restricted))
@interface EkoConversationChannelBuilder : NSObject <EkoChannelBuilderProtocol>

/**
 Channel type of the builder
 */
@property (assign, nonatomic) EkoChannelType channelType;

/**
 Sets single user id for this channel.
 */
- (void)setUserId:(NSString *)userId;

/**
 Sets user ids for this channel. This method is mandatory for converstation channel
 */
- (void)setUserIds:(NSArray<NSString *> *)userIds;

/**
 Sets metadata for this channel.
 */
- (void)setMetadata:(NSDictionary<NSString *, id> *)metaData;

/**
 Sets tags for this channel.
 */
- (void)setTags:(NSArray<NSString *> *)tags;

/**
 If this conversation is distinct, set it
 */
- (void)setIsDistinct:(BOOL)isDistinct;

/**
 Sets display name for this channel.
 */
- (void)setDisplayName:(NSString *)displayName;

/**
 Sets avatar info for this channel. Use EkoFileRepository to upload image and set the EkoImageData
 instance that you get in response over here.
 */
- (void)setAvatar:(EkoImageData *)avatarData;

@end

NS_ASSUME_NONNULL_END
