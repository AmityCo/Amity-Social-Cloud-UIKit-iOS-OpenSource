//
//  EkoStreamRepository.h
//  EkoChat
//
//  Created by Nutchaphon Rewik on 22/9/2563 BE.
//  Copyright © 2563 eko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EkoObject.h"
#import "EkoCollection.h"

@class EkoStream;
@class EkoObject;
@class EkoClient;
@class EkoCollection;
@class EkoLiveStreamURLInfo;
@class EkoStreamNotificationsManager;

NS_ASSUME_NONNULL_BEGIN

/// EkoStreamRepository manages stream objects
@interface EkoStreamRepository : NSObject

#pragma mark - Initializer

/// The context used to create the instance.
@property (nonnull, strong, readonly, nonatomic) EkoClient *client;

/// Designated intializer.
/// @param client A valid context instance.
- (nonnull instancetype)initWithClient:(nonnull EkoClient *)client NS_DESIGNATED_INITIALIZER;

#pragma mark - Query

/// Get the collection of the current live streams.
- (EkoCollection<EkoStream *> *)getLiveStreams;

/// Get a live object of stream, by id.
/// @param streamId The unique identifer of stream
- (EkoObject<EkoStream *> *)getStreamById:(nullable NSString *)streamId;

/// Retrieve a live stream url, in RTMP format.
///
/// The url conforms to RTMP protocol, with the following format...
///
/// - rtmp://server-ip-address[:port]/application/[appInstance]/[prefix:[path1[/path2/]]]streamName?auth_key
///
/// @example https://live-stream.ekochat.com/lion-company/david_gaming?auth_key=secret-1603178792
///
/// @param stream The stream instance to retrieve live url.
/// @param completion Return EkoLiveStreamURLInfo if success, otherwise return an error.
- (void)getLiveUrlForStream:(nonnull EkoStream *)stream
                 completion:(void (^)(EkoLiveStreamURLInfo * _Nullable urlInfo, NSError * _Nullable error))completion;

/* Not used in this version.
/// @abstract User Level Notification Management object.
@property (nonnull, readonly, nonatomic) EkoStreamNotificationsManager *notificationManager;
 */

#pragma mark - Prevent default initializer

/// Block call of `init` and `new` because this object cannot be created directly
- (instancetype)init NS_UNAVAILABLE;

/// Block call of `init` and `new` because this object cannot be created directly
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
