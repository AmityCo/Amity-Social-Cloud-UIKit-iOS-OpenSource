//
//  EkoFilePostBuilder.h
//  EkoChat
//
//  Created by Nishan Niraula on 6/18/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoBuilder.h"
#import "EkoFileData.h"


NS_ASSUME_NONNULL_BEGIN

@interface EkoFilePostBuilder : NSObject <EkoPostBuilder>

/**
 Sets the text for this post.
 */
- (void)setText:(NSString *)text;

/**
 Sets the file data for this Post. Files should be uploaded using EkoFileRepository. Those uploaded files data
 should be set here. This will automatically link that uploaded files to your post.
*/
- (void)setFileData:(NSArray<EkoFileData *> *)fileData;


@end

NS_ASSUME_NONNULL_END
