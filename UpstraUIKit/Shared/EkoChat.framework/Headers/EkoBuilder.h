//
//  EkoBuilder.h
//  EkoChat
//
//  Created by Nishan Niraula on 6/15/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoChannel.h"

@protocol EkoPostBuilder <NSObject>

/**
 Returns the JSON representation of the data object needed for post
 */
- (NSDictionary<NSString *, id> *)build;

@end

@protocol EkoCommunityBuilder <NSObject>

/**
 Returns the JSON representation of the data object needed for group
 */
- (NSDictionary<NSString *, id> *)build;

@end


@protocol EkoChannelBuilderProtocol <NSObject>

/**
 Channel type for the builder.
 */
@property (assign, nonatomic) EkoChannelType channelType;

/**
 Returns the JSON representation of the data object needed for channel
 */
- (NSDictionary<NSString *, id> *)build;

@end


