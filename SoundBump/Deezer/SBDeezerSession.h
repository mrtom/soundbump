//
//  SBDeezerSession.h
//  SoundBump
//
//  Created by Tom Elliott on 27/09/2013.
//  Copyright (c) 2013 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DeezerConnect.h"

#define kDeezerAppId @"100041"

@class DeezerUser;

@protocol DeezerSessionConnectionDelegate;
@protocol DeezerSessionRequestDelegate;

@interface SBDeezerSession : NSObject <DeezerSessionDelegate, DeezerRequestDelegate>

@property (nonatomic, assign)   id<DeezerSessionConnectionDelegate> connectionDelegate;
@property (nonatomic, assign)   id<DeezerSessionRequestDelegate>    requestDelegate;
@property (nonatomic, readonly) DeezerConnect* deezerConnect;
@property (nonatomic, retain)   DeezerUser* currentUser;

+ (SBDeezerSession *)sharedSession;

#pragma mark - Connection
- (void)connectToDeezerWithPermissions:(NSArray*)permissionsArray;
- (void)disconnect;
- (BOOL)isSessionValid;

@end
