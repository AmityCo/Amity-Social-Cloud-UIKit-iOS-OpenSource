//
//  EkoStream.h
//  EkoChat
//
//  Created by Nutchaphon Rewik on 22/9/2563 BE.
//  Copyright © 2563 eko. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// EkoStream provides essential data describing a single stream.
__attribute__((objc_subclassing_restricted))
@interface EkoStream : NSObject

/// The unique of stream object.
@property (nonnull, strong, readonly, nonatomic) NSString *streamId;

/// The title of stream object.
@property (nullable, strong, readonly, nonatomic) NSString *title;

/// The description of stream object.
@property (nullable, strong, readonly, nonatomic) NSString *streamDescription;

/// This property is set to true when the stream is now live.
@property (assign, readonly, nonatomic) BOOL isLive;

/// Meta data of the stream.
@property (nonnull, strong, readonly, nonatomic) NSDictionary<NSString *, id> *meta;

/// The time when the stream was created.
@property (nonnull, strong, readonly, nonatomic) NSDate *createdAt;

/// The last time when the stream is updated.
@property (nullable, strong, readonly, nonatomic) NSDate *updatedAt;

/// The user identifier who created this stream.
@property (nullable, strong, readonly, nonatomic) NSString *userId;

#pragma mark - Prevent default initializer

/// Block call of `init` and `new` because this object cannot be created directly
- (instancetype)init NS_UNAVAILABLE;

/// Block call of `init` and `new` because this object cannot be created directly
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
