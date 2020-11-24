//
//  EkoChannel.h
//
//  Created by eko on 1/18/18.
//  Copyright © 2018 eko. All rights reserved.
//

#import "EkoObject.h"
#import <Foundation/Foundation.h>

@class EkoChannel;
@class EkoChannelParticipation;
@class EkoChannelModeration;
@class EkoChannelMembership;
@class EkoImageData;

/**
 * All Channel Type
 */
typedef NS_ENUM(NSUInteger, EkoChannelType) {
    EkoChannelTypeStandard,
    EkoChannelTypePrivate,
    EkoChannelTypeBroadcast,
    EkoChannelTypeConversation,
    EkoChannelTypeByTypes,
    EkoChannelTypeLive,
    EkoChannelTypeCommunity
};

/**
 * Channel Type that allowed to be created
 */
typedef NS_ENUM(NSUInteger, EkoChannelCreateType) {
    EkoChannelCreateTypeStandard,
    EkoChannelCreateTypePrivate
};

NS_ASSUME_NONNULL_BEGIN

/**
 * Channel
 */
__attribute__((objc_subclassing_restricted))
@interface EkoChannel : NSObject

/**
 * The unique identifier for the channel
 */
@property (strong, readonly, nonatomic) NSString *channelId;

/**
 * Channel type
 */
@property (assign, readonly, nonatomic) enum EkoChannelType channelType;

/**
 * Channel metadata
 */
@property (nullable, strong, readonly, nonatomic) NSDictionary<NSString *, id> *metadata;

/**
 * The display name for the channel
 */
@property (nullable, strong, readonly, nonatomic) NSString *displayName;

/*
 * The current user membership type in the channel
 */
@property (readonly) EkoChannelMembershipType currentUserMembership;

/**
 * isDistinct
 */
@property (readonly, nonatomic) BOOL isDistinct;

/**
 * isMuted
 */
@property (readonly, nonatomic) BOOL isMuted;

/**
 * isRateLimited
 */
@property (readonly, nonatomic) BOOL isRateLimited;

/**
 * Unread messages for the current user in the channel
 */
@property (readonly, nonatomic) NSInteger unreadCount;

/**
 * Total number of users in this channel
 */
@property (readonly, nonatomic) NSInteger memberCount;

/**
 * Total number of messages in this channel
 */
@property (readonly, nonatomic) NSInteger messageCount;

/**
   Returns a participation instance
 */
@property (readonly, nonatomic) EkoChannelParticipation *participation;

/**
 * The current user channel membership object
 */
@property (nullable, readonly, nonatomic) EkoChannelMembership *currentMembership;

/**
   A moderation instance
 */
@property (readonly, nonatomic) EkoChannelModeration *moderate;

/**
   The channel tags
 */
@property (nonnull, assign, readonly, nonatomic) NSArray <NSString *> *tags;


/**
   @abstract The channel last activity
   @discussion The last activity is updated for various reasons, for example:

     - new channel tags are set

     - a new channel name is set

     - a new message has been received

     - etc
 */
@property (strong, nonatomic) NSDate *lastActivity;

/**
 If this channel has been deleted already
 */
@property (assign, nonatomic) BOOL isDeleted;

/**
   @abstract Returns a channel type from create channel type enum.
   @note This is a helper method to helps user can convert this enum automatically to a channel type

   @param type Indicates the create channel enum type
   @return A channel type enum
 */
+ (EkoChannelType )channelTypeForCreateType:(EkoChannelCreateType)type;

/**
 * File id for the avatar for this Channel. This can be used in
 * EkoFileRepository to download actual UIImage instance.
 */
@property (nullable, strong, nonatomic) NSString *avatarFileId;

/**
 Gets the image data associated with this Channel.
 
 @return: Returns EkoImageData if present. Else returns nil.
 */
-(void)getAvatarInfo:(void (^ _Nonnull)(EkoImageData * _Nullable imageData))completion;

/**
   Block call of `init` and `new` because this object cannot be created directly
 **/
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
