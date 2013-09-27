//
//  SBViewController.m
//  SoundBump
//
//  Created by Tom Elliott on 27/09/2013.
//  Copyright (c) 2013 Facebook. All rights reserved.
//

#import "SBViewController.h"
#import "BeaconFinder.h"

#import "PTPusher.h"

static const NSString *kDeezerAppID = @"125081";
static const NSString *kPusherAppKey = @"dcc6ab0c66a103f8d7e5";

@interface SBViewController () <BeaconFinderDelegate>

@property (nonatomic, strong) BeaconFinder *beaconFinder;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) PTPusher *pusherClient;

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
  
  NSMutableArray* permissionsArray = [NSMutableArray arrayWithObjects:@"basic_access", @"email", @"offline_access", nil];
  [_deezerConnect authorize:permissionsArray];
  
  // Setup Pusher
  _pusherClient = [PTPusher pusherWithKey:kPusherAppKey delegate:self encrypted:YES];
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

- (void)request:(DeezerRequest *)request didFailWithError:(NSError *)error
{
  NSLog(@"Deezer request failed with error %@", error);
}

- (void)request:(DeezerRequest *)request didReceiveResponse:(NSData *)response
{
  NSLog(@"Received response from Deezer");
}

#pragma mark - PTPusherDelegate methods

- (void)pusher:(PTPusher *)pusher connectionDidConnect:(PTPusherConnection *)connection
{
  NSLog(@"Pusher connected");
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection didDisconnectWithError:(NSError *)error
{
  NSLog(@"Pusher disconnected with error %@", error);
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection failedWithError:(NSError *)error
{
  NSLog(@"Pusher failed with error %@", error);
}

- (void)pusher:(PTPusher *)pusher connectionWillReconnect:(PTPusherConnection *)connection afterDelay:(NSTimeInterval)delay
{
  NSLog(@"Pusher will try and reconnect, after a delay of %f seconds", delay);
}

@end
