//
//  EKoImagePostBuilder.h
//  EkoChat
//
//  Created by Nishan Niraula on 6/18/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoBuilder.h"
#import "EkoImageData.h"

@import UIKit.UIImage;

NS_ASSUME_NONNULL_BEGIN

@interface EkoImagePostBuilder : NSObject <EkoPostBuilder>

/**
Sets the text for this post.
*/
- (void)setText: (NSString *)text;

/**
 Sets the Image data for this Post. Image should be uploaded using EkoFileRepository. Those uploaded image data
 should be set here. This will automatically link that uploaded files to your post.
*/
- (void)setImageData: (NSArray<EkoImageData *> *)imageData;

@end

NS_ASSUME_NONNULL_END
