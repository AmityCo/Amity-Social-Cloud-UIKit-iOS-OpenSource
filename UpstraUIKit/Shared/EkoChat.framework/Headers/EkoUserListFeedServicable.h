//
//  EkoUserListFeedServicable.h
//  EkoChat
//
//  Created by Michael Abadi Santoso on 4/13/20.
//  Copyright © 2020 eko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EkoCollection.h"
#import "EkoObject.h"
#import "EkoChannel.h"

@protocol EkoUserListFeedServicable <NSObject>

@required
- (nonnull EkoCollection<EkoUser *> *)searchUser:(nonnull NSString *)displayName
                                          sortBy:(EkoUserSortOption)sortBy;

- (nonnull EkoCollection<EkoUser *> *)getAllUsersSortedBy:(EkoUserSortOption)sortBy;

@end
