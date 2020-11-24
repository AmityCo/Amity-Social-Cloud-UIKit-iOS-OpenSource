//
//  EkoChannelQuery.h
//  EkoChat
//
//  Created by Michael Abadi Santoso on 2/3/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoEnums.h"
#import "EkoCollection.h"
#import "EkoChannel.h"
#import "EkoClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface EkoChannelQuery : NSObject

@property (nonatomic, assign) EkoClient *client;
@property (nullable, nonatomic, strong) NSSet<NSString *> *types;
@property (nonatomic, assign) EkoChannelQueryFilter filter;
@property (nonnull, nonatomic, strong) NSArray<NSString *> *includingTags;
@property (nonnull, nonatomic, strong) NSArray<NSString *> *excludingTags;
@property (assign, nonatomic) BOOL includeDeletedChannels;

- (nonnull EkoCollection<EkoChannel *> *)query;

@end

NS_ASSUME_NONNULL_END
