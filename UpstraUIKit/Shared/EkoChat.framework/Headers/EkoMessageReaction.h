//
//  EkoMessageReaction.h
//  EkoChat
//
//  Created by Michael Abadi Santoso on 12/26/19.
//  Copyright © 2019 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoEnums.h"

@class EkoMessageReaction;
@class EkoUser;

/**
 Reaction object
 */
__attribute__((objc_subclassing_restricted))
@interface EkoMessageReaction : NSObject

/**
 Uniquely identifies this message reaction.
 */
@property (nonnull, strong, readonly, nonatomic) NSString *reactionId;

/**
 Uniquely identifies this reaction for message.
 */
@property (nonnull, strong, readonly, nonatomic) NSString *messageId;

/**
 Identifies the name of the reaction.
 */
@property (nonnull, strong, readonly, nonatomic) NSString *reactionName;

/**
 The message creation time.
 */
@property (nonnull, strong, readonly, nonatomic) NSDate *createdAtDate;

/**
 The reference of reaction type, default to always message.
 */
@property (readonly, nonatomic) EkoReferenceType referenceType;

/**
   The reactor user id to this message reaction.
 */
@property (nonnull, strong, readonly, nonatomic) NSString *reactorId;

/**
   The reactor display name to this message reaction.
 */
@property (nonnull, strong, readonly, nonatomic) NSString *reactorDisplayName;

@end
