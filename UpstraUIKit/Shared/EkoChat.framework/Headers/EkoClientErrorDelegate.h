//
//  EkoClientErrorDelegate.h
//  EkoChat
//
//  Created by Federico Zanetello on 5/11/18.
//  Copyright © 2018 eko. All rights reserved.
//

@protocol EkoClientErrorDelegate <NSObject>

- (void)didReceiveAsyncError:(nonnull NSError *)error;

@end