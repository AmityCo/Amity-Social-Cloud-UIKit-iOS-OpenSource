//
//  EkoByTypesChannelQuery.h
//  EkoChat
//
//  Created by Michael Abadi Santoso on 2/5/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoEnums.h"
#import "EkoChannelQuery.h"
#import "EkoByTypesChannelQueryBuilder.h"

NS_ASSUME_NONNULL_BEGIN

@interface EkoByTypesChannelQuery : EkoChannelQuery

+ (instancetype)makeWithBuilder:(EkoByTypesChannelQueryBuilder *)builder
                         client:(EkoClient *)client;

@end

NS_ASSUME_NONNULL_END
