//
//  SBViewController.h
//  SoundBump
//
//  Created by Tom Elliott on 27/09/2013.
//  Copyright (c) 2013 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DeezerConnect.h"
#import "SBPusherDelegate.h"

@class DeezerUser;

@protocol DeezerSessionConnectionDelegate;

@interface SBViewController : UIViewController<DeezerSessionDelegate, SBPusherDelegate>

@property (strong, nonatomic) IBOutlet UIButton *BeatButton;
@property (strong, nonatomic) IBOutlet UIButton *boomBox;

- (IBAction)sendBeat:(id)sender;

@end
