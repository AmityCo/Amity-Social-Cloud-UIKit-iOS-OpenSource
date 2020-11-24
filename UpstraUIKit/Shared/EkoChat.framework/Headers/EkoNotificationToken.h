//
//  EkoNotificationToken.h
//  EkoChat
//
//  Created by eko on 2/20/18.
//  Copyright © 2018 eko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EkoNotificationToken : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (void)invalidate;

@end