//
//  EkoMessageEditor.h
//  EkoChat
//
//  Created by eko on 2/19/18.
//  Copyright © 2018 eko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EkoClient.h"
#import "EkoCollection.h"
#import "EkoObject.h"

@class EkoMessage;

/**
   A editor encapsulates methods for managing messages.
 */
@interface EkoMessageEditor : NSObject

/**
   The context used to create the instance.
 */
@property (nonnull, strong, readonly, nonatomic) EkoClient *client;

/**
   The message Id associated with the instance.
 */
@property (nonnull, strong, readonly, nonatomic) NSString *messageId;

/**
   Designated intializer.   
   @param client A valid context instance.
 */
- (nonnull instancetype)initWithClient:(nonnull EkoClient *)client
                             messageId:(nonnull NSString *)messageId NS_DESIGNATED_INITIALIZER;

/**
   Edits the text message.
   @param text The new text
   @param completion A block executed when the request has completed.
 */
- (void)editText:(nonnull NSString *)text
      completion:(EkoRequestCompletion _Nullable)completion;

/**
   Edits the custom message.
   @param text The new custom message
   @param completion A block executed when the request has completed..
 */
- (void)editCustomMessage:(nonnull NSDictionary<NSString *, id> *)customMessage
               completion:(EkoRequestCompletion _Nullable)completion;

/**
   Deletes the message.
   @param completion  A block executed when the request has completed.
 */
- (void)deleteWithCompletion:(nullable EkoRequestCompletion)completion;

/**
   Block call of `init` and `new` because this object cannot be created directly.
 **/
- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end
