//
//  EkoPrivateChannelQuery.h
//  EkoChat
//
//  Created by Michael Abadi Santoso on 2/3/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoEnums.h"
#import "EkoChannelQuery.h"
#import "EkoPrivateChannelQueryBuilder.h"

NS_ASSUME_NONNULL_BEGIN

@interface EkoPrivateChannelQuery : EkoChannelQuery

+ (instancetype)makeWithBuilder:(EkoPrivateChannelQueryBuilder *)builder
                         client:(EkoClient *)client;

@end

NS_ASSUME_NONNULL_END
