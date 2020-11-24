//
//  EkoCommunityUpdateDataBuilder.h
//  EkoChat
//
//  Created by Michael Abadi on 23/07/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import "EkoBuilder.h"
#import "EkoImageData.h"

NS_ASSUME_NONNULL_BEGIN

@interface EkoCommunityUpdateDataBuilder : NSObject <EkoCommunityBuilder>

/**
 Sets the current display name
 */
- (void)setDisplayName:(NSString *)displayName;

/**
 Sets the current description
 */
- (void)setCommunityDescription:(NSString *)communityDescription;

/**
Sets the current status public or not
*/
- (void)setIsPublic:(BOOL)isPublic;

/**
 Sets the current metadata
 */
- (void)setMetadata:(NSDictionary<NSString *, id> *)metadata;

/**
 Sets the community avatar, set nil if you want to remove it
 */
- (void)setAvatar:(nullable EkoImageData *)image;

/**
 Sets category id for community
 */
- (void)setCategoryIds:(nonnull NSArray<NSString *> *)categoryIds;

@end

NS_ASSUME_NONNULL_END

