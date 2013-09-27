//
//  SBPusher.h
//  SoundBump
//
//  Created by Tom Elliott on 27/09/2013.
//  Copyright (c) 2013 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PTPusherDelegate.h"
#import "SBPusherDelegate.h"

@interface SBPusher : NSObject <PTPusherDelegate>

@property (nonatomic, strong) id<SBPusherDelegate> delegate;

- (void)sendBeat;

@end
