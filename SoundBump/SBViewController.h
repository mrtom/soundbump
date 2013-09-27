//
//  SBViewController.h
//  SoundBump
//
//  Created by Tom Elliott on 27/09/2013.
//  Copyright (c) 2013 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

#import "DeezerConnect.h"
#import "PTPusherDelegate.h"

@class DeezerUser;

@protocol DeezerSessionConnectionDelegate;

@interface SBViewController : UIViewController<CLLocationManagerDelegate, DeezerSessionDelegate, DeezerRequestDelegate, PTPusherDelegate>

@end
