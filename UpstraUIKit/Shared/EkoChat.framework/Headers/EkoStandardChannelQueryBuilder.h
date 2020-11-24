//
//  EkoStandardChannelQueryBuilder.h
//  EkoChat
//
//  Created by Michael Abadi Santoso on 2/4/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoEnums.h"
#import "EkoClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface EkoStandardChannelQueryBuilder : NSObject

@property (nonatomic, assign) EkoChannelQueryFilter filter;
@property (nonnull, nonatomic, strong) NSArray<NSString *> *includingTags;
@property (nonnull, nonatomic, strong) NSArray<NSString *> *excludingTags;
@property (assign, nonatomic) BOOL includeDeletedChannels;

- (nonnull instancetype)initWithChannelQueryFilter:(EkoChannelQueryFilter)filter
                                     includingTags:(nullable NSArray<NSString *> *)includingTags
                                     excludingTags:(nullable NSArray<NSString *> *)excludingTags
                                    includeDeleted:(BOOL)includeDeletedChannels NS_DESIGNATED_INITIALIZER;

- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
