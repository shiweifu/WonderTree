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
  BOOL result = NO;
  NSDictionary *params = @{@"username": self.username,
                           @"password": [self.password md5],
                           @"questionid": @0,
                           @"answder": @"" ,
                           @"loginsubmit": @"true",
                           @"cookietime": @259200};
//  STHTTPRequest *request = [self requestWithURL:URL_LOGIN];
  STHTTPRequest *request = [STHTTPRequest requestWithURLString:URL_LOGIN];
  [request setHTTPMethod:@"POST"];
  [request setHeaderWithName:@"User-Agent" value:USER_AGENT];
  [request setPOSTDictionary:params];

  NSError *err = nil;
  NSString *responseString = [request startSynchronousWithError:&err];
  if([responseString containsString:@"欢迎您回来"])
  {
    result = YES;
    //TODO  get token


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

@end
