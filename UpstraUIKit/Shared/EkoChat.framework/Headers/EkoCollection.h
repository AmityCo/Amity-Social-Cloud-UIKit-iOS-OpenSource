//
//  EkoCollection.h
//  EkoChat
//
//  Created by eko on 1/28/18.
//  Copyright © 2018 eko. All rights reserved.
//

#import "EkoEnums.h"
#import <Foundation/Foundation.h>

@class EkoCollection;
@class EkoNotificationToken;
@class EkoCollectionChange;



NS_ASSUME_NONNULL_BEGIN

/**
   A collection is a container type returned from queries. Clients can request to load more and observe insertions and changes to the objects in the collection. Initially the count will be zero. Observers will be notified of changes.
 */
@interface EkoCollection<__covariant ObjectType> : NSObject

// if the current data is considered stale or if it's fresh data from the server
@property (readonly, nonatomic) EkoDataStatus dataStatus;

// stores the current local data status
@property (readonly, nonatomic) EkoLoadingStatus loadingStatus;

// stores if there is a previous page to query
@property (readonly, nonatomic) BOOL hasPrevious;

// stores if there is a next page to query
@property (readonly, nonatomic) BOOL hasNext;

/**
 * The number objects
 *
 * @return NSUInteger
 */
- (NSUInteger)count;

/**
 * Returns an instance at a given index
 *
 * @param idx An index in the collection
 * @return an object
 */
- (nullable ObjectType)objectAtIndex:(NSUInteger)idx;

/**
   Reset the current records being displayed to the default last page
 */
- (void)resetPage;

/**
   Requests more objects to load if any are available
 */
- (void)previousPage;

/**
   Requests more objects to load if any are available
 */
- (void)nextPage;

/**
   Adds a block to observe changes in the collection
   @param block called when the collection or any of the underlying objects have changed
   @return EkoNotificationToken object that should be retained to continue to observe.
 */
- (nonnull EkoNotificationToken *)observeWithBlock:(void (^)(EkoCollection<ObjectType> * _Nonnull collection, EkoCollectionChange * _Nullable changes, NSError * _Nullable error))block;
/**
   Adds a block to observe changes in the collection exactly once
   @param block called exactly once when the collection or any of the underlying objects have changed
   @return EkoNotificationToken object that should be retained to continue to observe.
 */
- (nonnull EkoNotificationToken *)observeOnceWithBlock:(void (^)(EkoCollection<ObjectType> * _Nonnull collection, EkoCollectionChange * _Nullable changes, NSError * _Nullable error))block;
/**
   Block call of `init` and `new` because EkoObject cannot be created directly
 **/
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

/**
 *  Represents changes in a EkoCollection
 */
@interface EkoCollectionChange : NSObject

/**
 * The indexes of objects inserted
 */
@property (nullable, strong, readonly, nonatomic) NSArray <NSNumber *> *insertions;

/**
 * The indexes of objects deleted
 */
@property (nullable, strong, readonly, nonatomic) NSArray <NSNumber *> *deletions;

/**
 * The indexes of objects modified
 */
@property (nullable, strong, readonly, nonatomic) NSArray <NSNumber *> *modifications;

@end

NS_ASSUME_NONNULL_END