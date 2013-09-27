//
//  BeaconManager.m
//  BrightonDome
//
//  Created by Alan Cannistraro on 9/26/13.
//  Copyright (c) 2013 Facebook. All rights reserved.
//

#import "BeaconAdvertiser.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BeaconAdvertiser () <CBPeripheralManagerDelegate>
@property (nonatomic, strong) CLBeaconRegion *region;
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, strong) NSUUID *uuid;
@property (nonatomic) CLBeaconMajorValue major;
@property (nonatomic) CLBeaconMinorValue minor;
@property (nonatomic) NSString *identifier;
@property (nonatomic) NSString *restoreIdentifier;
@property (nonatomic, strong) dispatch_queue_t peripheralQueue;
@end

@implementation BeaconAdvertiser

- (id)init
{
  if (self = [super init]) {
    self.uuid = [[NSUUID alloc] initWithUUIDString:@"064149EF-EAD1-4CFD-BECD-E0544EF95F22"];
    self.major = 1;
    self.minor = 1;
    self.identifier = @"FacebookPage";
    self.peripheralQueue = dispatch_queue_create("BeaconManagerPeripheralQueue", 0);
  }
  return self;
}

- (void)start
{
  self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:self.peripheralQueue options:nil];
}

#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral;
{
  NSLog(@"peripheral %@, state = %d", peripheral, peripheral.state);
  if (peripheral.state == 5) {
    self.region = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid major:self.major minor:self.minor identifier:self.identifier];
    NSDictionary *peripheralData = [self.region peripheralDataWithMeasuredPower:@-60];
    
    [self.peripheralManager startAdvertising:peripheralData];
  }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
  NSLog(@"did start error = %@", error);
}

// Extras?

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
  NSLog(@"Added service - w00p w00p!");
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic

{
  NSLog(@"Did subsribe to characteristic");
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
  NSLog(@"Did unsubscribe to characteristic");
}

- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral
{
  NSLog(@"Hey, I'm ready to update subscribers");
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request
{
  NSLog(@"Did receive read request...");
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests
{
  NSLog(@"Did receive write request...");
}


@end
