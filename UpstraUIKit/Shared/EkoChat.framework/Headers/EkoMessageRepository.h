//
//  EkoMessageRepository.h
//  EkoChat
//
//  Created by eko on 1/25/18.
//  Copyright © 2018 eko. All rights reserved.
//

@import Foundation;

#import "EkoClient.h"
#import "EkoCollection.h"
#import "EkoMessage.h"
#import "EkoObject.h"
#import "EkoUser.h"
#import "EkoReaction.h"

@import UIKit.UIImage;

/**
 Repository provides access messages and collections.
 */
@interface EkoMessageRepository : NSObject

/**
 The context used to create the instance.
 */
@property (nonnull, strong, readonly, nonatomic) EkoClient *client;

/**
 Designated intializer.
 
 @param client A valid context instance.
 */
- (nonnull instancetype)initWithClient:(nonnull EkoClient *)client NS_DESIGNATED_INITIALIZER;

/**
 Creates a new custom message (convenience method).
 
 @param channelId The channel we want to create a message in.
 @param data Message (custom) data.
 @return The EkoMessage live object.
 
 @note Behind the scenes this methods calls `NSJSONSerialization`, which states
 that an object that may be converted to JSON must have the following
 properties:
 
 - Top level object is an NSArray or NSDictionary.
 
 - All objects are NSString, NSNumber, NSArray, NSDictionary, or NSNull.
 
 - All dictionary keys are NSStrings.
 
 - NSNumbers are not NaN or infinity.
 
 Failing to do so will result in an exception.
 */
- (nonnull EkoObject<EkoMessage *> *)createCustomMessageWithChannelId:(nonnull NSString *)channelId
                                                                 data:(nonnull NSDictionary<NSString *, id> *)data;

/**
 Creates a new custom message (convenience method).
 
 @param channelId A channel Identifier.
 @param data Message (custom) data.
 @param tags An array of tags (you can store here whatever you want).
 
 @note Behind the scenes this methods calls `NSJSONSerialization`, which states
 that an object that may be converted to JSON must have the following
 properties:
 
 - Top level object is an NSArray or NSDictionary.
 
 - All objects are NSString, NSNumber, NSArray, NSDictionary, or NSNull.
 
 - All dictionary keys are NSStrings.
 
 - NSNumbers are not NaN or infinity.
 
 Failing to do so will result in an exception.
 */
- (nonnull EkoObject<EkoMessage *> *)createCustomMessageWithChannelId:(nonnull NSString *)channelId
                                                                 data:(nonnull NSDictionary<NSString *, id> *)data
                                                                 tags:(nullable NSArray<NSString *> *)tags;

/**
 Creates a new custom message (convenience method).
 
 @param channelId The channel we want to create a message in.
 @param data Message (custom) data.
 @param parentId The new message parent (note: this cannot be changed later).
 @return The EkoMessage live object.
 
 @note Behind the scenes this methods calls `NSJSONSerialization`, which states
 that an object that may be converted to JSON must have the following
 properties:
 
 - Top level object is an NSArray or NSDictionary.
 
 - All objects are NSString, NSNumber, NSArray, NSDictionary, or NSNull.
 
 - All dictionary keys are NSStrings.
 
 - NSNumbers are not NaN or infinity.
 
 Failing to do so will result in an exception.
 */
- (nonnull EkoObject<EkoMessage *> *)createCustomMessageWithChannelId:(nonnull NSString *)channelId
                                                                 data:(nonnull NSString *)data
                                                             parentId:(nullable NSString *)parentId;

/**
 Creates a new custom message.
 
 @param channelId The channel we want to create a message in.
 @param data Message (custom) data.
 @param tags An array of tags (you can store here whatever you want)
 @param parentId The new message parent (note: this cannot be changed later).
 @return The EkoMessage live object.
 
 @note Behind the scenes this methods calls `NSJSONSerialization`, which states
 that an object that may be converted to JSON must have the following
 properties:
 
 - Top level object is an NSArray or NSDictionary.
 
 - All objects are NSString, NSNumber, NSArray, NSDictionary, or NSNull.
 
 - All dictionary keys are NSStrings.
 
 - NSNumbers are not NaN or infinity.
 
 Failing to do so will result in an exception.
 */
- (nonnull EkoObject<EkoMessage *> *)createCustomMessageWithChannelId:(nonnull NSString *)channelId
                                                                 data:(nonnull NSDictionary<NSString *, id> *)data
                                                                 tags:(nullable NSArray<NSString *> *)tags
                                                             parentId:(nullable NSString *)parentId;

/**
 Creates a new text message (convenience method).
 
 @param channelId The channel we want to create a message in.
 @param text The text message to be sent.
 @return The EkoMessage live object.
 */
- (nonnull EkoObject<EkoMessage *> *)createTextMessageWithChannelId:(nonnull NSString *)channelId
                                                               text:(nonnull NSString *)text;

/**
 Creates a new text message (convenience method).
 
 @param channelId A channel Identifier.
 @param text Message text.
 @param tags An array of tags (you can store here whatever you want).
 */
- (nonnull EkoObject<EkoMessage *> *)createTextMessageWithChannelId:(nonnull NSString *)channelId
                                                               text:(nonnull NSString *)text
                                                               tags:(nullable NSArray<NSString *> *)tags;

/**
 Creates a new text message (convenience method).
 
 @param channelId The channel we want to create a message in.
 @param text The text message to be sent.
 @param parentId The new message parent (note: this cannot be changed later).
 @return The EkoMessage live object.
 */
- (nonnull EkoObject<EkoMessage *> *)createTextMessageWithChannelId:(nonnull NSString *)channelId
                                                               text:(nonnull NSString *)text
                                                           parentId:(nullable NSString *)parentId;

/**
 Creates a new text message.
 
 @param channelId The channel we want to create a message in.
 @param text The text message to be sent.
 @param tags An array of tags (you can store here whatever you want).
 @param parentId The new message parent (note: this cannot be changed later).
 @return The EkoMessage live object.
 */
- (nonnull EkoObject<EkoMessage *> *)createTextMessageWithChannelId:(nonnull NSString *)channelId
                                                               text:(nonnull NSString *)text
                                                               tags:(nullable NSArray<NSString *> *)tags
                                                           parentId:(nullable NSString *)parentId;

/**
 Creates a new image message (convenience method).
 
 @param channelId The channel we want to create a message in.
 @param image The `UIImage` to be sent (will be sent as JPG).
 @param caption The image caption.
 @param fullImage Whether or not the image should be sent at full resolution.
 @return The `EkoMessage` live object.
 */
- (nonnull EkoObject<EkoMessage *> *)createImageMessageWithChannelId:(nonnull NSString *)channelId
                                                               image:(nonnull UIImage *)image
                                                             caption:(nullable NSString *)caption
                                                           fullImage:(BOOL)fullImage;

/**
 * Creates a new image message (convenience method).
 *
 * @param channelId A channel Identifier.
 * @param image UIImage to be sent (will be sent as JPG).
 * @param fullImage whether or not the image should be sent at full resolution.
 * @param tags An array of tags (you can store here whatever you want).
 */
- (nonnull EkoObject<EkoMessage *> *)createImageMessageWithChannelId:(nonnull NSString *)channelId
                                                               image:(nonnull UIImage *)image
                                                             caption:(nullable NSString *)caption
                                                           fullImage:(BOOL)fullImage
                                                                tags:(nullable NSArray<NSString *> *)tags;

/**
 Creates a new image message (convenience method).
 
 @param channelId The channel we want to create a message in.
 @param image The `UIImage` to be sent (will be sent as JPG).
 @param caption The image caption.
 @param fullImage Whether or not the image should be sent at full resolution.
 @param parentId  The new message parent (note: this cannot be changed later).
 @return The `EkoMessage` live object.
 */
- (nonnull EkoObject<EkoMessage *> *)createImageMessageWithChannelId:(nonnull NSString *)channelId
                                                               image:(nonnull UIImage *)image
                                                             caption:(nullable NSString *)caption
                                                           fullImage:(BOOL)fullImage
                                                            parentId:(nullable NSString *)parentId;

/**
 Creates a new image message.
 
 @param channelId A channel Identifier.
 @param image UIImage to be sent (will be sent as JPG).
 @param fullImage whether or not the image should be sent at full resolution.
 @param tags An array of tags (you can store here whatever you want).
 @param parentId  The new message parent (note: this cannot be changed later).
 */
- (nonnull EkoObject<EkoMessage *> *)createImageMessageWithChannelId:(nonnull NSString *)channelId
                                                               image:(nonnull UIImage *)image
                                                             caption:(nullable NSString *)caption
                                                           fullImage:(BOOL)fullImage
                                                                tags:(nullable NSArray<NSString *> *)tags
                                                            parentId:(nullable NSString *)parentId;

/**
 Creates a new file message.
 @param channelId A channel Identifier.
 @param data File Data to be sent (will be sent as NSData).
 @param filename File name to be sent (will be sent as NSString).
 @param tags An array of tags (you can store here whatever you want).
 @param parentId  The new message parent (note: this cannot be changed later).
 */
- (nullable EkoObject<EkoMessage *> *)createFileMessageWithChannelId:(nonnull NSString *)channelId
                                                                data:(nonnull NSData *)data
                                                            filename:(nullable NSString *)filename
                                                                tags:(nullable NSArray<NSString *> *)tags
                                                            parentId:(nullable NSString *)parentId
                                                          completion:(EkoRequestCompletion _Nullable)completion;

/**
 @abstract Creates a collection of all messages filtered by channel id.
 
 @discussion
 When observing changes on the collection, the only time EkoCollectionChange
 gives back a deletion update (on messages) is when the user has been banned
 or has left the channel:
 to confirm this, you can also observe changes in the EkoChannel object
 (if this also gets deleted, you have either left the channel or you've been
 banned).
 
 @remarks
 Let's say that a channel has the messages (in chronological order):
 ABC...XYZ
 
 When `reverse` is set to:
 
 - `false`, we will fetch the first (oldest)
 messages in chronological order: ABC first, then the next page etc.
 
 - `true`, we will fetch the last (newest) messages
 in reverse-chronological order: ZYX first, then the previous page etc.
 
 It's up to the developer to call the right `loadNext`/`loadPrevious` page in
 the returned collection based on the `reverse` value:
 
 - `loadNext` loads newer messages in comparison with the last loaded page
 
 - `loadPrevious` loads older messages in comparison with the last loaded page
 
 @note when asking for more messages, based on the reverse preference,
 you'll need to ask for the next page (if the reverse is `false`) or the
 previous page (if the reverse is `true`).
 
 @param channelId The Channel of which messages we are interested in.
 @param reverse Whether we'd like the collection in chronological order or not.
 @return The messages collection.
 */
- (nonnull EkoCollection<EkoMessage *> *)messagesWithChannelId:(nonnull NSString *)channelId
                                                       reverse:(BOOL)reverse;

/**
 Creates and returns a collection of all messages filtered by the given
 `channelId`, and tags (convenience method).
 
 @note A message is matched when it contains ANY tag listed in includingTags,
 and contains NONE of the tags listed in excludingTags.
 
 @param channelId The channel identifier of the channel we're interested in
 @param includingTags The list of required message tags, pass an empty array to
 ignore this requirement.
 @param excludingTags The list of tags required not to be set in the messages,
 pass an empty array to ignore this requirement.
 @return The `EkoMessage` live collection.
 */
- (nonnull EkoCollection<EkoMessage *> *)messagesWithChannelId:(nonnull NSString *)channelId
                                                 includingTags:(nonnull NSArray<NSString *> *)includingTags
                                                 excludingTags:(nonnull NSArray<NSString *> *)excludingTags
                                                       reverse:(BOOL)reverse;

/**
 Creates and returns a collection of all messages filtered by the given
 `channelId`, and `parentId` (convenience method).
 
 @param channelId The channel identifier of the channel we're interested in
 @param filterByParentId Whether we're initerested in filtering by parentId or
 not.
 @param parentId The `messageId` of the parent whose child we're interested in.
 @return The `EkoMessage` live collection.
 */
- (nonnull EkoCollection<EkoMessage *> *)messagesWithChannelId:(nonnull NSString *)channelId
                                              filterByParentId:(BOOL)filterByParentId
                                                      parentId:(nullable NSString *)parentId
                                                       reverse:(BOOL)reverse;

/**
 Creates and returns a collection of all messages filtered by the given
 `channelId`, tags, and `parentId`.
 
 @note A message is matched when it contains ANY tag listed in includingTags,
 and contains NONE of the tags listed in excludingTags.
 
 @param channelId The channel identifier of the channel we're interested in
 @param includingTags The list of required message tags, pass an empty array to
 ignore this requirement.
 @param excludingTags The list of tags required not to be set in the messages,
 pass an empty array to ignore this requirement.
 @param filterByParentId Whether we're initerested in filtering by parentId or
 not.
 @param parentId The `messageId` of the parent whose child we're interested in.
 @param reverse Whether we'd like the collection in chronological order or not.
 @return The `EkoMessage` live collection.
 */
- (nonnull EkoCollection<EkoMessage *> *)messagesWithChannelId:(nonnull NSString *)channelId
                                                 includingTags:(nonnull NSArray<NSString *> *)includingTags
                                                 excludingTags:(nonnull NSArray<NSString *> *)excludingTags
                                              filterByParentId:(BOOL)filterByParentId
                                                      parentId:(nullable NSString *)parentId
                                                       reverse:(BOOL)reverse;


/**
 Get all of the reactions on the specific message.
 @param messageId The related message id to be observed.
 @return The `EkoReaction` live collection.
 */
- (nonnull EkoCollection<EkoReaction *> *)allMessageReactionsWithMessageId:(nonnull NSString *)messageId;

/**
 Sets the tags for the given message.
 
 As long as the user is a member of a channel, the user can set the tags to any
 message of that channel.
 
 @param messageId A valid Message Id
 @param tags An array of tags
 */
- (void)setTagsForMessage:(nonnull NSString *)messageId
                     tags:(nullable NSArray<NSString *> *)tags
               completion:(nullable EkoRequestCompletion)completion;

/**
 Gets an existing message by message Id
 */
- (EkoObject<EkoMessage *> * _Nullable)getMessage:(nonnull NSString *)messageId;

/**
 Removes all failed messages.
 */
- (void)deleteFailedMessages:(EkoRequestCompletion _Nullable)completion;

/**
 Removes particular failed message
 */
- (void)deleteFailedMessage:(nonnull NSString *)messageId completion:(nullable EkoRequestCompletion)completion;

/// Block call of `init` and `new` because this object cannot be created directly
- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end
