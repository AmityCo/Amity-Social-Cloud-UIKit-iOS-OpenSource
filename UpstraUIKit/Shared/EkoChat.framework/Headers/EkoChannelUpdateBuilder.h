//
//  EkoChannelUpdateBuilder.h
//  EkoChat
//
//  Created by Nishan Niraula on 9/29/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoImageData.h"
#import "EkoClient.h"
#import "EkoChannel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Builder to update the channel. All methods are optional.
 */
@interface EkoChannelUpdateBuilder : NSObject

@property (strong, readonly, nonatomic) EkoClient *client;

/**
 Default initializer. Do not initialize this class yourself.
 */
- (instancetype)initWithId:(NSString *)channelId andClient:(EkoClient *)client NS_DESIGNATED_INITIALIZER;

/**
 Sets display name for channel. Default value is nil.
 */
- (void)setDisplayName:(NSString *)displayName;

/**
 Sets medata for the channel. Default is empty dictionary.
 */
- (void)setMetadata:(NSDictionary<NSString *, id> *)metaData;

/**
 Sets avatar info for this channel. Use EkoFileRepository to upload image and set the EkoImageData
 instance that you get in response over here. To remove the avatar, pass nil.
 */
- (void)setAvatar:(nullable EkoImageData *)avatarData;

/**
 Sets tags for channel. Default is empty array
 */
- (void)setTags:(NSArray<NSString *> *)tags;

/**
 Starts the update request for this channel.
 */
- (nonnull EkoObject<EkoChannel *> *)update;

// Disable default initializer
- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
