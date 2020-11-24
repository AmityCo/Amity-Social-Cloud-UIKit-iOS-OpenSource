//
//  EkoMediaRepository.h
//  EkoChat
//
//  Created by Federico Zanetello on 5/7/18.
//  Copyright © 2018 eko. All rights reserved.
//

@import Foundation;
#import "EkoClient.h"
#import "EkoMessage.h"
@import UIKit;

/**
 * Provides access to the media associated with messages
 */
@interface EkoMediaRepository : NSObject

/**
 * The context used to create the instance
 */
@property (nonnull, strong, readonly, nonatomic) EkoClient *client;

/**
 * Designated intializer
 * @param client A valid context instance
 */
- (nonnull instancetype)initWithClient:(nonnull EkoClient *)client NS_DESIGNATED_INITIALIZER;

/**
 * Downloads the image for the given messageId. This method resumes (or starts) the download for the image.
 *
 * @param messageId A message Identifier
 * @param size of the media to donwload (defaults to medium if nil)
 * @param resultHandler the block to be called with the requested image (or eventual error)
 */
- (void)getImageForMessageId:(nonnull NSString *)messageId
                        size:(EkoMediaSize)size
               resultHandler:(void(^ _Nonnull)(UIImage * __nullable image, EkoMediaSize size, NSError * __nullable error))resultHandler;
// in V2 this will also support a progressHandler

/**
 * Downloads the file for the given messageId. This method resumes (or starts) the download for the file.
 *
 * @param messageId A message Identifier
 * @param resultHandler the block to be called with the requested file (or eventual error)
 */
- (void)getFileForMessageId:(nonnull NSString *)messageId
              resultHandler:(void(^ _Nonnull)(NSData * __nullable data, NSError * __nullable error))resultHandler;

    
/**
 * Stops (pauses) the media download for the given messageId (note: for images use cancelGetMediaForMessageId:size:)
 *
 * @param messageId A message Identifier
 */
// -(void)cancelGetMediaForMessageId:(nonnull NSString *)messageId; // not in use yet

/**
 * Stops (pauses) the media download for the given messageId and EkoMediaSize
 *
 * @param messageId A message Identifier
 * @param size A proper EkoMediaSize
 */
- (void)cancelGetMediaForMessageId:(nonnull NSString *)messageId size:(EkoMediaSize)size;

/**
 * Block call of `init` and `new` because this object cannot be created directly
 **/
- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end
