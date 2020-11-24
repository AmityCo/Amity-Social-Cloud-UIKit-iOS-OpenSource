//
//  EkoCommunityCategory.h
//  EkoChat
//
//  Created by Nishan Niraula on 7/20/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EkoImageData;

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_subclassing_restricted))
@interface EkoCommunityCategory : NSObject

/**
 Id of the category
 */
@property (nonatomic, strong) NSString *categoryId;

/**
 Name of the category
 */
@property (nonatomic, strong) NSString *name;

/**
 File id for avatar of the category
 */
@property (nonatomic, strong) NSString *avatarFileId;

/**
 Date when this Category was created
 */
@property (strong, nonatomic) NSDate *createdAt;

/**
 Date when this Category was last updated
 */
@property (strong, nonatomic) NSDate *updatedAt;

/**
 * The avatar model of the community category
 */
@property (nullable, strong, readonly, nonatomic) EkoImageData *avatar;

/**
 If its the deleted category
 */
@property (assign, nonatomic) BOOL isDeleted;

@end

NS_ASSUME_NONNULL_END
