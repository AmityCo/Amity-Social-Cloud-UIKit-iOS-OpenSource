//
//  EkoChannelMembershipPrivileges.h
//  EkoChat
//
//  Created by Federico Zanetello on 11/4/18.
//  Copyright © 2018 eko. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface EkoChannelMembershipPrivileges : NSObject

/**
   Privileges
 */
@property (nullable, strong, readonly, nonatomic) NSArray <NSString *> *privileges;
@end