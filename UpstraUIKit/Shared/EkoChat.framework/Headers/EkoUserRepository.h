//
//  EkoUserRepository.h
//  EkoChat
//
//  Created by eko on 1/25/18.
//  Copyright © 2018 eko. All rights reserved.
//

@import Foundation;

#import "EkoClient.h"
#import "EkoObject.h"
#import "EkoUser.h"
#import "EkoUserListFeedServicable.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Repository provides access users and collections
 */
@interface EkoUserRepository : NSObject<EkoUserListFeedServicable>

@property (strong, readonly, nonatomic) EkoClient *client;

/**
   Designated intializer

   @param client A valid context instance
   @return returns the instance
 */
- (nonnull instancetype)initWithClient:(nonnull EkoClient *)client NS_DESIGNATED_INITIALIZER;

/**
   @param userId userId
 */
- (nonnull EkoObject<EkoUser *> *)userForId:(nonnull NSString *)userId;

/**
   Search an user base on the display name

   @param displayName The display name of the user we want to search
   @param sortBy The sort option provided by EkoUserSortOption
   @return returns the EkoCollection of all EkoUsers with the desired displayName
 */
- (nonnull EkoCollection<EkoUser *> *)searchUser:(NSString *)displayName
                                          sortBy:(EkoUserSortOption)sortBy;

/**
   Get all of the available users

   @param sortBy The sort option provided by EkoUserSortOption
   @return returns the EkoCollection of all EkoUsers
 */
- (nonnull EkoCollection<EkoUser *> *)getAllUsersSortedBy:(EkoUserSortOption)sortBy;

// Block call of `init` and `new` because this object cannot be created directly
- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
