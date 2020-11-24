//
//  EkoClient.h
//  EkoChat
//
//  Created by eko on 1/18/18.
//  Copyright © 2018 eko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EkoClientErrorDelegate.h"
#import "EkoEnums.h"
#import "EkoObject.h"
#import "EkoUserNotificationsManager.h"

@class EkoUser;
@class UIImage;

typedef void (^EkoRequestCompletion)(BOOL success, NSError * _Nullable error);

/**
 @abstract SDK entry point.
 @discussion A valid context instance should be used to create other SDK resources.
 @warning An instance of `EkoClient` should be initiated with an Application key and be retained by the caller.
 */
__attribute__((objc_subclassing_restricted))
@interface EkoClient : NSObject

/**
 @abstract Connection status.
 @note This property supports KVO.
 */
@property (readonly, nonatomic) EkoConnectionStatus connectionStatus;

/**
 @abstract The Id of the current user.
 */
@property (nullable, readonly, nonatomic) NSString *currentUserId;

/**
 @abstract The current user object.
 */
@property (nullable, readonly, nonatomic) EkoObject<EkoUser *> *currentUser;

/**
 @abstract User Level Notification Management object.
 */
@property (nonnull, readonly, nonatomic) EkoUserNotificationsManager *notificationManager;

/**
 @abstract The (optional) delegate to listen to async errors (force logout, bad sessions, ...).
 */
@property (nullable, weak, nonatomic) id<EkoClientErrorDelegate> clientErrorDelegate;

/**
 @abstract Creates an instance of `EkoClient` with provided API key.
 @param apiKey API key provided by Eko.
 @return A valid client instance or nul on invalid API key.
 */
+ (nullable EkoClient *)clientWithApiKey:(nonnull NSString *)apiKey;

/**
 @abstract Registers the the user with the current device.
 @note If the passed userId does not match the current user, the current user will be unregistered.
 @note the `displayName` passed value is ignored if the user has previously registered with this device, use `setDisplayName:completion:` instead.
 @param userId A user id. Required.
 @param displayName The display name of the user. Required.
 @param authToken: Extra authentication token to be used for secure device registration. This is optional. Please refer to our Authentication documentation for further details.
 */
- (void)registerDeviceWithUserId:(nonnull NSString *)userId
                     displayName:(nullable NSString *)displayName
                       authToken:(nullable NSString *)authToken;

/**
 @abstract Unregisters the current user associated with the device.
 @discussion The device will be unregisted from push notifications and data associated with the user will be removed from the device.
 */
- (void)unregisterDevice;

/**
 @abstract Register the current device (and the current logged-in user) to receive
 push notifications.
 @discussion You can call this method as many times as you'd like: the last call
 will always override any precedent state.
 As long as you call this function with a valid token, and after succesfully
 registering the SDK, you're guaranteed to receive only push notifications related
 to the current logged in user.
 Call `unregisterDevicePushNotificationForUserId:completion:` to stop receiving
 notifications for this user.
 Succesfully calling this method will override any precedent state: if this device
 was previously registered with a different user, the device will no more get any
 notification related to that user.
 @warning Once succesfully registered, this app will continue to receive
 notifications related to this user until the `unregisterDeviceForPushWithCompletion:`
 or another registration is made.
 @param deviceToken A globally unique token that identifies this device to Apple
 Push Notification service.
 @param completion A block executed when the request has successfully completed.
 */
- (void)registerDeviceForPushNotificationWithDeviceToken:(nonnull NSString *)deviceToken
                                              completion:(nullable EkoRequestCompletion)completion;

/**
 @abstract Unregister the current device to stop receiving any push notifications
 related to the given user userId. If no user is passed, the backend will remove
 any push notification token associated with this device.
 @discussion Call this method when you no longer wish to receive notifications for
 the previously registered user (for example when the user logs out).
 @warning Make sure that the completion block is called with success state, otherwise
 the Eko backend will keep sending push notifications related to the previous user.
 @param userId The userId of the user of which the SDK should no longer receive
 notifications.
 @param completion A block executed when the request has successfully completed.
 */
- (void)unregisterDevicePushNotificationForUserId:(nullable NSString *)userId
                                       completion:(void(^ _Nullable)(NSString * _Nullable, BOOL success, NSError * _Nullable error))completion;

/**
 @abstract Sets the display name for the current user.
 @param displayName String.
 @param completion A block executed when the request has successfully completed.
 */
- (void)setDisplayName:(nullable NSString *)displayName
            completion:(nullable EkoRequestCompletion)completion;

/**
 @abstract Sets the roles for the current user.
 @param roles an array of strings
 */
- (void)setRoles:(nonnull NSArray <NSString *> *)roles
      completion:(nullable EkoRequestCompletion)completion;

/**
 Sets the metadata for the user
 @param data A dictionary containing metadata
 */
- (void)setUserMetadata:(nullable NSDictionary<NSString *, id> *)data
             completion:(nullable EkoRequestCompletion)completion;

/**
 @abstract Sets the avatar for the current user.
 @param image an UIImage
 */
- (void)setAvatar:(nonnull UIImage *)image
       completion:(nullable EkoRequestCompletion)completion;

/**
 @abstract Sets the avatar for the current user.
 @param avatarUrl custom avatar URL string
 */
- (void)setAvatarCustomUrl:(nonnull NSString *)avatarUrl
                completion:(nullable EkoRequestCompletion)completion;

/**
 Sets description for this user.
 
 @param description: Description string
 */
- (void)setUserDescription:(nonnull NSString *)description
                completion:(nullable EkoRequestCompletion)completion;

/**
 Set configurations for sdk.
 */
+ (void)setEkoConfig:(nullable NSDictionary<NSString *, id> *)config;

/**
 Block call of `init` and `new` because this object cannot be created directly
 **/
- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end
