//
//  SBPusher.m
//  SoundBump
//
//  Created by Tom Elliott on 27/09/2013.
//  Copyright (c) 2013 Facebook. All rights reserved.
//

#import "SBPusher.h"

#import "PTPusher.h"

static const NSString *kEventName = @"client-beat-sent";
static const NSString *kDevChannelName = @"private-sound-bump-dev";

@interface SBPusher()

@property (nonatomic, strong) PTPusher *pusherClient;

@end

@implementation SBPusher

- (id)init
{
  self = [super init];
  if (self) {
    [self initCommon];
  }
  
  return self;
}

- (void)initCommon
{
  _isConnected = NO;
  
  _pusherClient = [PTPusher pusherWithKey:@"dcc6ab0c66a103f8d7e5" delegate:self encrypted:YES];
  _pusherClient.reconnectAutomatically = YES;
  [_pusherClient subscribeToChannelNamed:kDevChannelName];
  //[_pusherClient subscribeToPrivateChannelNamed:kDevChannelName];
  _pusherClient.authorizationURL = [NSURL URLWithString:@"http://telliott.net/soundbump/auth.php"];
  [_pusherClient bindToEventNamed:kEventName target:self action:@selector(receiveBeat)];
  
  [_pusherClient bindToEventNamed:@"pusher:subscription_succeeded" handleWithBlock:^(PTPusherEvent *event) {
    NSLog(@"Subscription to pusher channel succeeded");
  }];
  
}

#pragma mark - Public instance methods

- (void)sendBeat
{
  if (_isConnected) {
    [_pusherClient sendEventNamed:kEventName data:@"{\"name\":\"blah\"}" channel:kDevChannelName];    
  }
}

#pragma mark - Private instance methods

- (void)receiveBeat
{
  [self.delegate receiveBeat];
}

- (void)setIsConnected:(BOOL)isConnected
{
  _isConnected = isConnected;
  if (isConnected) {
    [self.delegate pusherOnline];
  } else {
    [self.delegate pusherOnline];
  }
}

#pragma mark - PTPusherDelegate methods

- (void)pusher:(PTPusher *)pusher connectionDidConnect:(PTPusherConnection *)connection
{
  self.isConnected = YES;
  NSLog(@"Pusher connected");
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection didDisconnectWithError:(NSError *)error
{
  self.isConnected = NO;
  NSLog(@"Pusher disconnected with error %@", error);
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection failedWithError:(NSError *)error
{
  self.isConnected = NO;
  NSLog(@"Pusher failed with error %@", error);
}

- (void)pusher:(PTPusher *)pusher connectionWillReconnect:(PTPusherConnection *)connection afterDelay:(NSTimeInterval)delay
{
  NSLog(@"Pusher will try and reconnect, after a delay of %f seconds", delay);
}

- (void)pusher:(PTPusher *)pusher willAuthorizeChannelWithRequest:(NSMutableURLRequest *)request
{
  [request setValue:@"some-authentication-token" forHTTPHeaderField:@"X-MyCustom-AuthTokenHeader"];
}

@end
