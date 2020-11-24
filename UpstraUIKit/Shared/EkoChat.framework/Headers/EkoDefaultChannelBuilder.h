//
//  EkoDefaultChannelBuilder.h
//  EkoChat
//
//  Created by Nishan Niraula on 8/19/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoChannel.h"
#import "EkoBuilder.h"
#import "EkoImageData.h"

NS_ASSUME_NONNULL_BEGIN

@interface EkoDefaultChannelBuilder : NSObject <EkoChannelBuilderProtocol>

@property (nullable, strong, nonatomic) NSString *channelDisplayName;
@property (nullable, strong, nonatomic) NSDictionary<NSString *, id> *channelMetadata;
@property (nullable, strong, nonatomic) NSArray<NSString *> *channelTags;
@property (nullable, strong, nonatomic) NSString *channelId;
@property (nullable, strong, nonatomic) NSArray<NSString *> *channelUserIds;
@property (assign, nonatomic) EkoChannelType channelType;
@property (nullable, strong, nonatomic) EkoImageData *avatarData;

/**
 Sets id for the channel. Default value is nil.
 */
- (void)setId:(NSString *)channelId;

/**
 Sets display name for channel. Default value is nil.
 */
- (void)setDisplayName:(NSString *)displayName;

/**
 Sets medata for the channel. Default is empty dictionary.
 */
- (void)setMetadata:(NSDictionary<NSString *, id> *)metaData;

/**
 Sets tags for channel. Default is empty array
 */
- (void)setTags:(NSArray<NSString *> *)tags;

/**
 Sets user ids for this channel.
 */
- (void)setUserIds:(NSArray<NSString *> *)userIds;

/**
 Sets avatar info for this channel. Use EkoFileRepository to upload image and set the EkoImageData
 instance that you get in response over here.
 */
- (void)setAvatar:(EkoImageData *)avatarData;

@end

NS_ASSUME_NONNULL_END
