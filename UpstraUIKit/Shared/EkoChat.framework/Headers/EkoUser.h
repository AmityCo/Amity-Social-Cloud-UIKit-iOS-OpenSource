//
//  EkoUser.h
//  EkoMessage
//
//  Created by eko on 1/18/18.
//  Copyright © 2018 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoImageData.h"

/**
 * User Object
 */
__attribute__((objc_subclassing_restricted))
@interface EkoUser : NSObject
/**
 * Id of the current user
 */
@property (nonnull, strong, readonly, nonatomic) NSString *userId;

/**
 * Display name for this user
 */
@property (nullable, strong, readonly, nonatomic) NSString *displayName;

/**
 * Timestamp when this user was first created
 */
@property (nonnull, strong, nonatomic) NSDate *createdAt;

/**
 * Timestamp when this user was last updated
 */
@property (nonnull, strong, nonatomic) NSDate *updatedAt;

/**
   Roles
 */
@property (nullable, assign, readonly, nonatomic) NSArray <NSString *> *roles;

/**
   Number of people that have flagged the user
 */
@property (assign, readonly, nonatomic) NSUInteger flagCount;

/**
 * User metadata
 */
@property (nullable, strong, readonly, nonatomic) NSDictionary<NSString *, id> *metadata;

/**
 * File id for the avatar for this user. This can be used in
 * EkoFileRepository to download actual UIImage instance.
 */
@property (nullable, strong, nonatomic) NSString *avatarFileId;

/**
 * Any custom url set as avatar for this user
 */
@property (nullable, strong, nonatomic) NSString *avatarCustomUrl;

/**
 * Description for this user
 */
@property (nonnull, strong, nonatomic) NSString *userDescription;

/**
 Returns file information about avatar if present
 */
-(void)getAvatarInfo:(void (^ _Nonnull)(EkoImageData * _Nullable imageData))completion;

@end
