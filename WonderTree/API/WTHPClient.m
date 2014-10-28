//
//  WTHPClient.m
//  WonderTree
//
//  Created by shiweifu on 10/26/14.
//  Copyright (c) 2014 weifu. All rights reserved.
//

#import <TMCache.h>
#import <STHTTPRequest.h>
#import "WTHPClient.h"
#import "WTUtils.h"
#import "NSString+ObjectiveSugar.h"
#import "NSArray+ObjectiveSugar.h"


static  WTHPClient *_instance = nil;

@interface WTHPClient()

//cdb_auth
@property (nonatomic, strong) NSString *authToken;

@end

@implementation WTHPClient


- (instancetype)initWithUsername:(NSString *)username
                        password:(NSString *)password
{
  self = [super init];
  if (self)
  {
    _username = username;
    _password = password;
  }

  BOOL b = [self login];
  if(!b)
  {
    return nil;
  }

  return self;
}

//login and refresh user info
- (BOOL)login
{
  //clean shared storeage cookie
  [STHTTPRequest clearSession];
  BOOL result = NO;
  NSDictionary *params = @{@"username": self.username,
                           @"password": [self.password md5],
                           @"questionid": @0,
                           @"answder": @"" ,
                           @"loginsubmit": @"true",
                           @"cookietime": @259200};
  STHTTPRequest *request = [STHTTPRequest requestWithURLString:URL_LOGIN];
//  [request setHTTPMethod:@"POST"];
  [request setPOSTDictionary:params];
  [request setHeaderWithName:@"User-Agent" value:USER_AGENT];

  NSError *err = nil;
  NSString *responseString = [request startSynchronousWithError:&err];
  if([responseString containsString:@"欢迎您回来"])
  {
    NSDictionary *headers = request.responseHeaders;
    NSString *cookies = headers[@"Set-Cookie"];

    NSArray *tmp = [cookies split:@";"];

    for (NSUInteger i = 0; i < tmp.count; ++i)
    {
      NSString *s = tmp[i];
      NSArray *pies = [s split:@"="];

      NSLog(@"your pies: %@", pies);

      if([[pies[0] strip] isEqualToString:@"cdb_auth"])
      {
        self.authToken = pies[1];
        result = YES;
        break;
      }
    }
  }

  self.isLogined = result;
  return result;
}

+ (instancetype)clientWithUsername:(NSString *)username
                          password:(NSString *)password
{
  return [[self alloc] initWithUsername:username password:password];
}


+ (WTHPClient *)sharedClient
{
  return _instance;
}

+ (void)setupSharedClientWithUsername:(NSString *)username
                             password:(NSString *)password
{
  _instance = [WTHPClient clientWithUsername:username
                                    password:password];
}


- (STHTTPRequest *)requestWithURL:(NSString *)url {
  if(!self.authToken) {
    return nil;
  }

  STHTTPRequest *request = [STHTTPRequest requestWithURLString:url];
  [request setHeaderWithName:@"Cookie" value:[NSString stringWithFormat:@"cdb_auth=%@;", self.authToken]];
  return request;
}


+ (NSArray *)currentUserCookie {
  NSHTTPCookieStorage *sharedCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
  NSArray *cookies = [sharedCookieStorage cookies];
  return cookies;
}

- (void)getUserInfoById:(NSString *)string
             onComplete:(void (^) (WTHPUser *, id))complete
{

}

@end


@implementation WTHPUser

- (instancetype)initWithUid:(NSString *)uid
{
  self = [super init];
  if (self)
  {
    _uid = uid;
  }

  return self;
}

+ (instancetype)userWithUid:(NSString *)uid
{
  return [[self alloc] initWithUid:uid];
}

@end

