//
//  EkoChannelBuilder.h
//  EkoChat
//
//  Created by Nishan Niraula on 9/28/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoClient.h"
#import "EkoChannel.h"
#import "EkoConversationChannelBuilder.h"
#import "EkoLiveChannelBuilder.h"
#import "EkoCommunityChannelBuilder.h"

NS_ASSUME_NONNULL_BEGIN

@interface EkoChannelBuilder : NSObject

@property (strong, readonly, nonatomic) EkoClient *client;

/**
 Default Initializer. Do not initialize this class yourself.
 */
- (instancetype)initWithClient:(EkoClient *)client NS_DESIGNATED_INITIALIZER;

/**
 Creates a conversation channel.
 */
- (nonnull EkoObject<EkoChannel *> *)conversationWithBuilder:(EkoConversationChannelBuilder *)builder;

/**
 Creates a live channel.
 */
- (nonnull EkoObject<EkoChannel *> *)liveWithBuilder:(EkoLiveChannelBuilder *)builder;

/**
 Creates a community channel,
 */
- (nonnull EkoObject<EkoChannel *> *)communityWithBuilder:(EkoCommunityChannelBuilder *)builder;

// Disable default initializer
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
