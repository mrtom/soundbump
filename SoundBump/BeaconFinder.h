//
//  BeaconFinder.h
//  SoundBump
//
//  Created by Alan Cannistraro on 9/27/13.
//  Copyright (c) 2013 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>


@protocol BeaconFinderDelegate;


@interface BeaconFinder : NSObject <CLLocationManagerDelegate>

@property (nonatomic, weak) id <BeaconFinderDelegate> delegate;

- (void)startFinding;

@end

@protocol BeaconFinderDelegate <NSObject>
- (void)beaconFinder:(BeaconFinder *)beaconFinder didFindWithProximity:(CLProximity)proximity;
- (void)beaconFinderDidExitRegion:(BeaconFinder *)beaconFinder;
@end
