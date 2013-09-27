//
//  SBViewController.m
//  SoundBump
//
//  Created by Tom Elliott on 27/09/2013.
//  Copyright (c) 2013 Facebook. All rights reserved.
//

#import "SBViewController.h"

#import <CoreLocation/CoreLocation.h>

static const NSString *kFacebookRawUUID = @"064149EF-EAD1-4CFD-BECD-E0544EF95F22";
static const NSString *kFacebookPageRegionID = @"FacebookPage";
static const NSString *kDeezerAppID = @"125081";

@interface SBViewController ()

@property CLLocationManager *locationManager;
@property(nonatomic, strong, readonly) NSUUID *facebookUUID;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation SBViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self initCommon];
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [self initCommon];
  }
  return self;
}

- (void)initCommon
{
  _facebookUUID = [[NSUUID alloc] initWithUUIDString:kFacebookRawUUID];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.locationManager = [CLLocationManager new];
  self.locationManager.delegate = self;
  
  UILabel *statusLabel = [[UILabel alloc] init];
  statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  statusLabel.frame = CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.height - 70);
  statusLabel.font = [UIFont boldSystemFontOfSize:60];
  statusLabel.numberOfLines = 3;
  statusLabel.textAlignment = UITextAlignmentCenter;
  [self.view addSubview:statusLabel];
  self.statusLabel = statusLabel;
  
  [self registerBeaconRegionWithUUID:_facebookUUID andIdentifier:[NSString stringWithFormat:@"%@", kFacebookPageRegionID]];
  
  // Connect with Deezer
  DeezerConnect *_deezerConnect = [[DeezerConnect alloc] initWithAppId:kDeezerAppID andDelegate:self];
  
  /* List of permissions available from the Deezer SDK web site */
  NSMutableArray* permissionsArray = [NSMutableArray arrayWithObjects:@"basic_access", @"email", @"offline_access", nil];
  [_deezerConnect authorize:permissionsArray];
}

- (void)viewDidUnload
{
  self.locationManager = nil;
}

-(void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)registerBeaconRegionWithUUID:(NSUUID *)proximityUUID andIdentifier:(NSString*)identifier {
  
  // Create the beacon region to be monitored.
  CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc]
                                  initWithProximityUUID:proximityUUID
                                  identifier:identifier];
  
  
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
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
  
  if ([beacons count] > 0) {
    CLBeacon *nearestExhibit = [beacons firstObject];
    
    // Present the exhibit-specific UI only when
    // the user is relatively close to the exhibit.
    CLProximity proximity = nearestExhibit.proximity;
    if (proximity == CLProximityImmediate) {
      self.statusLabel.text = @"Say 'HI' to Philip Su!!!";
      self.view.backgroundColor = [UIColor greenColor];
    }
    else {
      self.statusLabel.text = @"Say 'BYE' to Philip Su.  :(";
      self.view.backgroundColor = [UIColor redColor];
    }
    NSLog(@"proximity = %d", nearestExhibit.proximity);
    
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
  NSLog(@"Did determine state %d", state);
  if (state == CLRegionStateInside) {
    NSLog(@"Found!");
  }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
  NSLog(@"Did fail");
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
  NSLog(@"Monitoring started");
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
  NSLog(@"did fail");
}

#pragma mark - DeezerSessionDelegate methods

- (void)deezerDidLogin {
  NSLog(@"Deezer did login");
}

- (void)deezerDidNotLogin:(BOOL)cancelled {
  NSLog(@"Deezer Did not login %@", cancelled ? @"Cancelled" : @"Not Cancelled");
}

- (void)deezerDidLogout {
  NSLog(@"Deezer Did logout");
}

@end
