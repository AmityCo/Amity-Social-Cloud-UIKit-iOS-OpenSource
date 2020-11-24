//
//  EkoUserNotificationsManager.h
//  EkoChat
//
//  Created by Federico Zanetello on 6/5/19.
//  Copyright © 2019 eko. All rights reserved.
//

/**
   @abstract Responsible to manage the user level push notification settings.
 */
@interface EkoUserNotificationsManager : NSObject

/**
   @abstract The completion block type.
   @discussion As these push notifications settings are per user and not per device,
   any request will go through the backend.

   @param success The outcome of the callback.
   @param error (optional) The error from the backend.
 */
    typedef void (^EkoRequestCompletion)(BOOL success,
     NSError * _Nullable error);

/**
   @abstract Updates the user level push notification setting.
   @note This setting will take effect on every device used by the user.
   If the user wishes to stop receiving notifications only on this device,
   then unregister push notifications with this device instead.

   @param isAllowed Whether or not the user would like to receive any push notifications.
   @param completion A block executed when the request has completed.
 */
- (void)setIsAllowed:(BOOL)isAllowed
          completion:(nullable EkoRequestCompletion)completion;

/**
   @abstract Retrieve the current user level push notification state.
   @note This setting is per user, not per device.

   @param completion A block executed when the request has completed.
 */
- (void)isAllowedWithCompletion:(void(^ _Nonnull)(BOOL isAllowed,
 NSError * _Nullable))completion;

/**
   Block call of `init` and `new` because this object cannot be created directly
 **/
- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;
@end