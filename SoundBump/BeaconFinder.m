//
//  BeaconFinder.m
//  SoundBump
//
//  Created by Alan Cannistraro on 9/27/13.
//  Copyright (c) 2013 Facebook. All rights reserved.
//

#import "BeaconFinder.h"
#import <CoreLocation/CoreLocation.h>


static const NSString *kFacebookRawUUID = @"064149EF-EAD1-4CFD-BECD-E0544EF95F22";
static const NSString *kFacebookPageRegionID = @"FacebookPage";

@interface BeaconFinder ()

@property CLLocationManager *locationManager;
@property(nonatomic, strong, readonly) NSUUID *facebookUUID;

@end


@implementation BeaconFinder

- (id)init
{
  if (self = [super init]) {
    _facebookUUID = [[NSUUID alloc] initWithUUIDString:(NSString *)kFacebookRawUUID];
  }
  return self;
}

- (void)dealloc
{
  self.locationManager.delegate = nil;
}

- (void)startFinding
{
  self.locationManager = [CLLocationManager new];
  self.locationManager.delegate = self;

  // Create the beacon region to be monitored.
  CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc]
                                  initWithProximityUUID:_facebookUUID
                                  identifier:(NSString *)kFacebookPageRegionID];
  
  
  // Register the beacon region with the location manager.
  [self.locationManager startMonitoringForRegion:beaconRegion];
  [self.locationManager startRangingBeaconsInRegion:beaconRegion];
  
  NSLog(@"Started monitoring region");
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
  NSLog(@"Entered Beacon region!");
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
  NSLog(@"Exited Beacon region!");
  [self.delegate beaconFinderDidExitRegion:self];
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
  
  if ([beacons count] > 0) {
    CLBeacon *nearestExhibit = [beacons firstObject];
    
    // Present the exhibit-specific UI only when
    // the user is relatively close to the exhibit.
    CLProximity proximity = nearestExhibit.proximity;
    [self.delegate beaconFinder:self didFindWithProximity:proximity];
    NSLog(@"proximity = %d", (int)proximity);
    //    if (CLProximityNear == nearestExhibit.proximity) {
    //      //[self presentExhibitInfoWithMajorValue:nearestExhibit.major.integerValue];
    //      NSLog(@"Blah");
    //    } else {
    //      NSLog(@"Foo");
    //      //[self dismissExhibitInfo];
    //    }
  }
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
  NSLog(@"Did determine state %d", (int)state);
  if (state == CLRegionStateInside) {
    NSLog(@"Found!");
  }
  else if (state == CLRegionStateOutside) {
    [self.delegate beaconFinderDidExitRegion:self];
  }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
  NSLog(@"Location manager monitoring did fail with error %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
  NSLog(@"Monitoring started");
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
  NSLog(@"Location manager did fail with error %@", error);
}

@end
