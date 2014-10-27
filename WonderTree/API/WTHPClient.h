//
//  WTHPClient.h
//  WonderTree
//
//  Created by shiweifu on 10/26/14.
//  Copyright (c) 2014 weifu. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const URL_LOGIN = @"http://www.hi-pda.com/forum/logging.php?action=login&loginsubmit=yes&inajax=1";
static NSString *const URL_DISCOVER   = @"http://www.hi-pda.com/forum/forumdisplay.php?fid=2";
static NSString *const USER_AGENT  = @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10) AppleWebKit/600.1.22 (KHTML, like Gecko) Version/8.0";

@interface WTHPClient : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, assign) BOOL isLogined;


- (instancetype)initWithUsername:(NSString *)username
                        password:(NSString *)password;

+ (instancetype)clientWithUsername:(NSString *)username
                          password:(NSString *)password;


+ (WTHPClient *)sharedClient;

+ (void)setupSharedClientWithUsername:(NSString *)string
                             password:(NSString *)password;
@end
