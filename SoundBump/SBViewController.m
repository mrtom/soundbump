//
//  SBViewController.m
//  SoundBump
//
//  Created by Tom Elliott on 27/09/2013.
//  Copyright (c) 2013 Facebook. All rights reserved.
//

#import "SBViewController.h"
#import "BeaconFinder.h"


static const NSString *kDeezerAppID = @"125081";

@interface SBViewController () <BeaconFinderDelegate>

@property (nonatomic, strong) BeaconFinder *beaconFinder;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation SBViewController


- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor blackColor];

  
  UILabel *statusLabel = [[UILabel alloc] init];
  statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  statusLabel.frame = CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.height - 70);
  statusLabel.font = [UIFont boldSystemFontOfSize:60];
  statusLabel.numberOfLines = 3;
  statusLabel.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:statusLabel];
  self.statusLabel = statusLabel;
  
  self.beaconFinder = [[BeaconFinder alloc] init];
  self.beaconFinder.delegate = self;
  [self.beaconFinder startFinding];
  
  // Connect with Deezer
  DeezerConnect *_deezerConnect = [[DeezerConnect alloc] initWithAppId:kDeezerAppID andDelegate:self];
  
  /* List of permissions available from the Deezer SDK web site */
  NSMutableArray* permissionsArray = [NSMutableArray arrayWithObjects:@"basic_access", @"email", @"offline_access", nil];
  [_deezerConnect authorize:permissionsArray];
}


#pragma mark - BeaconFinderDelegate

- (void)beaconFinder:(BeaconFinder *)beaconFinder didFindWithProximity:(CLProximity)proximity
{
  if (proximity == CLProximityImmediate) {
    self.view.backgroundColor = [UIColor greenColor];
  }
  else if (proximity == CLProximityUnknown) {
    self.view.backgroundColor = [UIColor blackColor];
  }
  else {
    self.view.backgroundColor = [UIColor redColor];
  }
  self.statusLabel.text = [NSString stringWithFormat:@"%d", (int)proximity];
}

- (void)beaconFinderDidExitRegion:(BeaconFinder *)beaconFinder
{
  self.view.backgroundColor = [UIColor blackColor];
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
