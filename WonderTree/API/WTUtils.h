//
// Created by shiweifu on 10/27/14.
// Copyright (c) 2014 weifu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WTUtils : NSObject

+ (NSString *)GBKresponse2String:(id) responseObject;

@end

@interface NSString (MD5)
- (NSString *)md5;
@end
