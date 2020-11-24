//
//  EkoConversationChannelQuery.h
//  EkoChat
//
//  Created by Michael Abadi Santoso on 3/9/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoEnums.h"
#import "EkoChannelQuery.h"
#import "EkoConversationChannelQueryBuilder.h"

NS_ASSUME_NONNULL_BEGIN

@interface EkoConversationChannelQuery : EkoChannelQuery

+ (instancetype)makeWithBuilder:(EkoConversationChannelQueryBuilder *)builder
                         client:(EkoClient *)client;

@end

NS_ASSUME_NONNULL_END
