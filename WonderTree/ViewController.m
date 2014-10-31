//
//  ViewController.m
//  WonderTree
//
//  Created by shiweifu on 10/26/14.
//  Copyright (c) 2014 weifu. All rights reserved.
//

#import "ViewController.h"
#import "TMCache.h"
#import "WTUtils.h"
#import "NSArray+ObjectiveSugar.h"
#import "WTHPClient.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.

  NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"user.json"];
  NSData *data = [NSData dataWithContentsOfFile:path];


  NSDictionary *userConfig = [NSJSONSerialization JSONObjectWithData:data
                                                       options:NSJSONReadingMutableLeaves
                                                         error:nil];


  [WTHPClient setupSharedClientWithUsername:userConfig[@"username"]
                                   password:userConfig[@"password"]];
  WTHPClient *client = [WTHPClient sharedClient];


  [client getUserInfoByUsername:@"zhuyi"
               onComplete:^(WTHPUser *user, id ext) {
    if(!user)
    {
      NSLog(@"%@", ext);
      return;
    }
    else
    {
      NSLog(@"%@", user);
    }
  }];

  [client getGroupByFid:@"2"
                   page:@"1"
             onComplete:^(NSArray *posts, id ext){

  }];



//  [client getAllGroup onComplete:^(id a, id b){}];
//  [client getSubjectWithGroup:@"" subject:@"" onComplete:^(id a, id b){}]
//
//
//
//  [client postToGroup:@"" type:@"" subject:@"" content:@"" onComplete:^(id a, id b){}];
//  [client relayToSubject:@"" content:@""]

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
