//
//  SBDeezerSession.m
//  SoundBump
//
//  Created by Tom Elliott on 27/09/2013.
//  Copyright (c) 2013 Facebook. All rights reserved.
//

#import "SBDeezerSession.h"

#import "DeezerUser.h"
#import "JSONKit.h"

#define DEEZER_TOKEN_KEY @"DeezerTokenKey"
#define DEEZER_EXPIRATION_DATE_KEY @"DeezerExpirationDateKey"
#define DEEZER_USER_ID_KEY @"DeezerUserId"

@interface SBDeezerSession (Token_methods)
- (void)retrieveTokenAndExpirationDate;
- (void)saveToken:(NSString*)token andExpirationDate:(NSDate*)expirationDate forUserId:(NSString*)userId;
- (void)clearTokenAndExpirationDate;
@end

@interface SBDeezerSession (Requests_methods)
@end

@implementation SBDeezerSession

#pragma mark - NSObject

- (id)init {
  if (self = [super init]) {
    _deezerConnect = [[DeezerConnect alloc] initWithAppId:kDeezerAppId
                                              andDelegate:self];
    [self retrieveTokenAndExpirationDate];
  }
  return self;
}

#pragma mark - Connection
/**************\
 |* Connection *|
 \**************/

// See http://www.deezer.com/fr/developers/simpleapi/permissions
// for a description of the permissions
- (void)connectToDeezerWithPermissions:(NSArray*)permissionsArray {
  [_deezerConnect authorize:permissionsArray];
}

- (void)disconnect {
  [_deezerConnect logout];
}

- (BOOL)isSessionValid {
  return [_deezerConnect isSessionValid];
}

#pragma mark - Token
// The token needs to be saved on the device
- (void)retrieveTokenAndExpirationDate {
  NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
  [_deezerConnect setAccessToken:[standardUserDefaults objectForKey:DEEZER_TOKEN_KEY]];
  [_deezerConnect setExpirationDate:[standardUserDefaults objectForKey:DEEZER_EXPIRATION_DATE_KEY]];
  [_deezerConnect setUserId:[standardUserDefaults objectForKey:DEEZER_USER_ID_KEY]];
}

- (void)saveToken:(NSString*)token andExpirationDate:(NSDate*)expirationDate forUserId:(NSString*)userId {
  NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
  [standardUserDefaults setObject:token forKey:DEEZER_TOKEN_KEY];
  [standardUserDefaults setObject:expirationDate forKey:DEEZER_EXPIRATION_DATE_KEY];
  [standardUserDefaults setObject:userId forKey:DEEZER_USER_ID_KEY];
  [standardUserDefaults synchronize];
}

- (void)clearTokenAndExpirationDate {
  NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
  [standardUserDefaults removeObjectForKey:DEEZER_TOKEN_KEY];
  [standardUserDefaults removeObjectForKey:DEEZER_EXPIRATION_DATE_KEY];
  [standardUserDefaults removeObjectForKey:DEEZER_USER_ID_KEY];
  [standardUserDefaults synchronize];
}

@end
