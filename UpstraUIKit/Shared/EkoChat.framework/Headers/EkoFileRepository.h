//
//  EkoFileRepository.h
//  EkoChat
//
//  Created by Nishan Niraula on 7/8/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoClient.h"
#import "EkoMessage.h"
#import "EkoImageData.h"
#import "EkoFileData.h"

@class UIImage;
@class UploadableFile;

typedef void (^EkoFileUploadCompletion)(EkoFileData * _Nullable fileData, NSError * _Nullable error);
typedef void (^EkoImageUploadCompletion)(EkoImageData * _Nullable imageData, NSError * _Nullable error);
typedef void (^EkoUploadProgressHandler)(double progress);


NS_ASSUME_NONNULL_BEGIN

@interface EkoFileRepository : NSObject

@property (strong, readonly, nonatomic) EkoClient *client;

/**
   Designated intializer
   @param client A valid context instance
 */
- (instancetype)initWithClient:(EkoClient *)client NS_DESIGNATED_INITIALIZER;

/**
 Uploads an image to file service. This method allows you to track upload progress.
 
 @param image: UIImage to be uploaded
 @param progress: Returns progress value ranging from 0.0 - 1.0
 @param completion: Returns uploaded image data and failed upload if any.
 */
- (void)uploadImage:(UIImage *)image progress:(nullable EkoUploadProgressHandler)progressHandler completion:(EkoImageUploadCompletion)completionBlock;

/**
 Uploads file to File Service. This method allows you to track upload progress.
 @param file: A file to be uploaded.
 @param progress: Returns progress value ranging from 0.0 - 1.0
 @param completion: Returns uplaoded file data and failed upload if any.
 */
- (void)uploadFile:(UploadableFile *)file progress:(nullable EkoUploadProgressHandler)progressHandler completion:(EkoFileUploadCompletion)completionBlock;

/**
 Downloads the images from file service. Image is downloaded asynchronously.
 @discussion Image downloaded using EkoFileRepository are not cached by SDK.
 @param fileId : The file id for the image to be downloaded
 @param size : The size in which image is to be downloaded.
 @param completion Returns the downloaded image if success. Else returns error.
*/
- (void)downloadImage:(NSString *)fileId size:(EkoMediaSize)size completion:(void (^)(UIImage * _Nullable image, EkoMediaSize size, NSError * _Nullable error))completion;

/**
 Downloads the file from FileService. File is downloaded asynchronously
 @discussion Files downloaded using EkoFileRepository are not cached by SDK.
 @param fileId : Id of the file to be downloaded
 @param completion Returns the downloaded file if success. Else returns error
 */
- (void)downloadFile:(NSString *)fileId completion:(void (^)(NSData * _Nullable file, NSError * _Nullable error))completion;

/**
 Cancels the download of file from FileService
 
 @param fileId: Id of the file
 */
- (void)cancelFileDownload:(NSString *)fileId;

/**
 Cancels the download of images from File Service
 
 @param fileId: Id of the image file
 @param size: Size of image
 */
- (void)cancelImageDownload:(NSString *)fileId size:(EkoMediaSize)size;

/**
 Prevent direct initialization of this class.
 */
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
