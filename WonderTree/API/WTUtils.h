//
// Created by shiweifu on 10/27/14.
// Copyright (c) 2014 weifu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ObjectiveSugar/NSArray+ObjectiveSugar.h>

static NSString *const kSearchCaseSensitiveKey = @"kSearchCaseSensitiveKey";
static NSString *const kSearchWholeWordsKey    = @"kSearchWholeWordsKey";

@interface WTUtils : NSObject

+ (NSString *)GBKresponse2String:(id) responseObject;

+ (NSRegularExpression *)regularExpressionWithString:(NSString *)string options:(NSDictionary *)options;

+ (NSArray *)captureString:(NSString *)str withRegex:(NSString *)regexStr;

+ (NSArray *)extractThreads:(NSString *)string;

@end

@interface NSString (MD5)
- (NSString *)md5;
@end



@interface NSDate (string)

- (NSString *)stringWithFormat:(NSString *)format;

+ (NSDate *)dateFromString:(NSString *)string;

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

+ (NSDate *)firstDayOfMonth;

+ (NSDate *)lastDayOfMonth;

- (NSInteger)numberOfDaysInMonthCount;

@end

