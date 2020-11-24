//
//  EkoCommunityRepository.h
//  EkoChat
//
//  Created by Michael Abadi on 03/07/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoClient.h"
#import "EkoCollection.h"
#import "EkoEnums.h"
#import "EkoCommunityCategory.h"
#import "EkoBuilder.h"

@class EkoCommunity;
@class EkoCommunityMembership;

typedef void (^EkoCommunityRequestCompletion)(EkoCommunity * _Nullable, NSError * _Nullable);

NS_ASSUME_NONNULL_BEGIN

/**
 * Repository provides access to community and collections of communities
 */
@interface EkoCommunityRepository : NSObject


@property (strong, readonly, nonatomic) EkoClient *client;

/**
 Designated intializer
 @param client A valid context instance
 */
- (instancetype)initWithClient:(EkoClient *)client NS_DESIGNATED_INITIALIZER;

/**
 Create the which need a text represented by string value
 @param builder: A type of EkoCommunityBuilder object.
 */
- (void)createCommunity:(nonnull id<EkoCommunityBuilder>)builder completion:(nonnull EkoCommunityRequestCompletion)completion;

/**
 Update specific community with the updated data
 @param communityId A community id represent the group object
 @param builder: A type of EkoCommunityBuilder object. You can use EkoCommunityDataBuilder to update community data.
 */
- (void)updateCommunityWithCommunityId:(nonnull NSString *)communityId builder:(nonnull id<EkoCommunityBuilder>)builder completion:(nonnull EkoCommunityRequestCompletion)completion NS_SWIFT_NAME(updateCommunity(withId:builder:completion:));

/**
 Delete the specific community
 @param communityId A community id represent the community object
 */
- (void)deleteCommunityWithCommunityId:(nonnull NSString *)communityId
                            completion:(EkoRequestCompletion _Nullable)completion NS_SWIFT_NAME(deleteCommunity(withId:completion:));

/**
 Get the collection of communities.
 
 @param keyword: Keyword to search commnunities based on display name. Set it nil if you want to fetch all communities.
 @param filter: The filter option that user wish to select
 @param sortBy: The sort option that user wish to select
 @param categoryId: Category id for the community. This value is optional.
 @param includeDeleted: Should include deleted communities or not in the collection
 
 @return The EkoCollection of EkoCommunity  object. Observe the changes for getting the result.
 */
- (nonnull EkoCollection<EkoCommunity *> *)getCommunitiesWithKeyword:(nullable NSString *)keyword
                                                              filter:(EkoCommunityQueryFilter)filter
                                                              sortBy:(EkoCommunitySortOption)sortBy
                                                          categoryId:(nullable NSString *)categoryId
                                                      includeDeleted:(BOOL)includeDeletedCommunities;

/**
 Retrieves community for particular community id
 
 @param communityId The id for the community
 */
- (nonnull EkoObject<EkoCommunity *> *)getCommunityForCommunityId:(nonnull NSString *)communityId NS_SWIFT_NAME(getCommunity(withId:));

/**
 Fetches all the categories for community.
 
 @param sortBy: Sort option for categories
 @param includeDeleted: Should include deleted categories or not for collection
 */
- (nonnull EkoCollection<EkoCommunityCategory *> *)getAllCategories:(EkoCommunityCategoriesSortOption)sortBy includeDeleted:(BOOL)includeDeletedCategories;

/**
 Join community for particular community id
 
 @param communityId The id for the community
 */
- (void)joinCommunityWithCommunityId:(nonnull NSString *)communityId
                          completion:(EkoRequestCompletion _Nullable)completion;

/**
 Leave community for particular community id
 
 @param communityId The id for the community
 */
- (void)leaveCommunityWithCommunityId:(nonnull NSString *)communityId
                           completion:(EkoRequestCompletion _Nullable)completion;

/**
 Get collection of trending communities
 */
- (EkoCollection<EkoCommunity *> *)getTrendingCommunities;

/**
 Get collection of recommended communities
 */
- (EkoCollection<EkoCommunity *> *)getRecommendedCommunities;

/**
 Block call of `init` and `new` because this object cannot be created directly
 **/
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

