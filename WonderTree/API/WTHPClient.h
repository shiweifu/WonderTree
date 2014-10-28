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

- (void)getUserInfoById:(NSString *)string
             onComplete:(void (^) (WTHPUser *, id))complete;

+ (WTHPClient *)sharedClient;

+ (void)setupSharedClientWithUsername:(NSString *)string
                             password:(NSString *)password;

+ (NSArray *)currentUserCookie;

@end

@interface WTHPUser : NSObject

//用户id
@property (nonatomic, strong) NSString  *uid;
//用户昵称
@property (nonatomic, strong) NSString  *username;
//用户性别
@property (nonatomic, strong) NSString  *sex;
//注册日期
@property (nonatomic, strong) NSDate    *regDate;
//最后发帖
@property (nonatomic, strong) NSDate    *lastPost;
//上次登录
@property (nonatomic, strong) NSDate    *lastCheck;
//阅读权限
@property (nonatomic, strong) NSString  *permission;
//发帖级别
@property (nonatomic, strong) NSString  *level;
//发帖总数
@property (nonatomic, strong) NSNumber *postCount;
//积分
@property (nonatomic, strong) NSString *exploit;
//介绍
@property (nonatomic, strong) NSString  *introduction;

- (instancetype)initWithUid:(NSString *)uid;

+ (instancetype)userWithUid:(NSString *)uid;


@end


