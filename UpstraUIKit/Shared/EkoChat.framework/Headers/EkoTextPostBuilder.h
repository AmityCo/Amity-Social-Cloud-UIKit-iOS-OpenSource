//
//  EkoTextPostBuilder.h
//  EkoChat
//
//  Created by Nishan Niraula on 6/15/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import "EkoBuilder.h"

NS_ASSUME_NONNULL_BEGIN

@interface EkoTextPostBuilder : NSObject <EkoPostBuilder>

/**
 Sets the current text as  provided text
 */
- (void)setText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
