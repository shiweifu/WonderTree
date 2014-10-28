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
@property (nonatomic, strong) NSHTTPCookie *authCookie;

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
  __block BOOL result = NO;
  NSDictionary *params = @{@"username": self.username,
                           @"password": [self.password md5],
                           @"questionid": @0,
                           @"answder": @"" ,
                           @"loginsubmit": @"true",
                           @"cookietime": @259200};
  STHTTPRequest *request = [STHTTPRequest requestWithURLString:URL_LOGIN];
  [request setPOSTDictionary:params];

  NSError *err = nil;
  NSString *responseString = [request startSynchronousWithError:&err];
  if([responseString containsString:@"欢迎您回来"])
  {
    NSArray *arr = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    [arr each:^(NSHTTPCookie *c)
    {
      if([c.name isEqualToString:@"cdb_auth"])
      {
        self.authCookie = c;
        result = YES;
        return;
      }
    }];
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
  if(!self.authCookie) {
    return nil;
  }

  STHTTPRequest *request = [STHTTPRequest requestWithURLString:url];
  [request addCookieWithName:self.authCookie.name value:self.authCookie.value];
  [request setHeaderWithName:@"User-Agent" value:USER_AGENT];
  return request;
}

- (void)getUserInfoById:(NSString *)string
             onComplete:(void (^) (WTHPUser *, id))complete
{

}

- (void)getUserInfoByUsername:(NSString *)username
                   onComplete:(void (^) (WTHPUser *, id))complete
{
  NSString *url = [NSString stringWithFormat:URL_USERNAME_FMT, username];
  STHTTPRequest *request = [self requestWithURL:url];
  NSError *err;

  __block STHTTPRequest *tmpReq = request;

  [request setCompletionBlock:^(NSDictionary *headers, NSString *body)
  {
    if(!body && tmpReq.responseData) {
      SEL sel = NSSelectorFromString(@"stringWithData:encodingName:");
      body = ((id (*)(id, SEL, id, id))objc_msgSend)(tmpReq, sel, tmpReq.responseData, @"GBK");
    }

    WTHPUser *user = [WTHPUser userWithPage:body];
    complete(user, nil);
  }];
  [request setErrorBlock:^(NSError *error)
  {
    complete(nil, error);
  }];
  [request startAsynchronous];
}

@end


@implementation WTHPUser

- (instancetype)initWithPage:(NSString *)page
{
  self = [super init];
  if (self)
  {
    NSString *username = [WTUtils captureString:page
                                withRegex:REGEX_MATCH_USERNAME][0];

    self.username = username;

    NSArray *arr = [WTUtils captureString:page
                       withRegex:REGEX_MATCH_USERINFO];

    [arr each:^(NSString *s)
    {
      NSArray *parts = [s split:@": "];

      if([s containsString:@"注册日期"])
      {
        self.regDate = [NSDate dateFromString:parts[1] withFormat:@"YYYY-MM-DD"];
      }
      else if([s containsString:@"上次访问"])
      {
        self.lastCheck = parts[1];
      }
      else if([s containsString:@"最后发表"])
      {
        self.lastPost = [NSDate dateFromString:parts[1] withFormat:@"YYYY-MM-DD hh:mm"];
      }
      else if([s containsString:@"发帖数级别"])
      {
        self.level = parts[1];
      }
      else if([s containsString:@"阅读权限"])
      {
        self.permission = parts[1];
      }
      else if([s containsString:@"帖子"])
      {
        self.postCount = @([parts[1] integerValue]);
      }
    }];
  }

  return self;
}

+ (instancetype)userWithPage:(NSString *)page
{
  return [[self alloc] initWithPage:page];
}

@end

