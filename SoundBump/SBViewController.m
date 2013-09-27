//
//  SBViewController.m
//  SoundBump
//
//  Created by Tom Elliott on 27/09/2013.
//  Copyright (c) 2013 Facebook. All rights reserved.
//

#import "SBViewController.h"

#import <AudioToolbox/AudioToolbox.h>

#import "BeaconFinder.h"
#import "SBPusher.h"

static const NSString *kDeezerAppID = @"125081";

@interface SBViewController () <BeaconFinderDelegate>

@property (nonatomic, strong) BeaconFinder *beaconFinder;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) SBPusher *pusher;
@property (nonatomic, strong) DeezerConnect *deezerConnect;

@end

@implementation SBViewController

NSURL *phoneticAudioClip;
CFURLRef phonecitAudioClipRef;
SystemSoundID phonecitAudioClipObject;

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
  _deezerConnect = [[DeezerConnect alloc] initWithAppId:(NSString *)kDeezerAppID andDelegate:self];
  
  NSMutableArray* permissionsArray = [NSMutableArray arrayWithObjects:@"basic_access", @"email", @"offline_access", nil];
  [_deezerConnect authorize:permissionsArray];
  
  _pusher = [SBPusher new];
  _pusher.delegate = self;
}

#pragma mark - IBActions

- (IBAction)sendBeat:(id)sender
{
  [_pusher sendBeat];
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

#pragma mark - SBPusher delegate methods

- (void)receiveBeat
{
  _boomBox.alpha = 1.0f;
  [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(revertBeat:) userInfo:nil repeats:NO];
  
  // Play your 'beat'
  phoneticAudioClip = [[NSBundle mainBundle] URLForResource: @"tap" withExtension: @"aif"];
  phonecitAudioClipRef = (CFURLRef)CFBridgingRetain(phoneticAudioClip);
  
  AudioServicesCreateSystemSoundID (phonecitAudioClipRef, &phonecitAudioClipObject);
  AudioServicesAddSystemSoundCompletion(phonecitAudioClipObject, NULL, NULL, nil, (__bridge void *)self);
  AudioServicesPlaySystemSound(phonecitAudioClipObject);
}

- (void)revertBeat:(id)userInfo
{
  _boomBox.alpha = 0.0f;
}

- (void)pusherOnline
{
  self.BeatButton.alpha = 1.0f;
}

- (void)pusherOffline
{
  self.BeatButton.alpha = 0.0f;
}


@end
