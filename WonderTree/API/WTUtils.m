//
// Created by shiweifu on 10/27/14.
// Copyright (c) 2014 weifu. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "WTUtils.h"

@implementation WTUtils
{

}

+ (NSString *)GBKresponse2String:(id) responseObject {

  NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);

  NSString *src = [[NSString alloc] initWithData:responseObject encoding:gbkEncoding];

  if (!src) src = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

  return src;
}


// Create a regular expression with given string and options
+ (NSRegularExpression *)regularExpressionWithString:(NSString *)string options:(NSDictionary *)options
{
  // Create a regular expression
  BOOL isCaseSensitive = [options[kSearchCaseSensitiveKey] boolValue];
  BOOL isWholeWords = [options[kSearchWholeWordsKey] boolValue];

  NSError *error = NULL;
  NSRegularExpressionOptions regexOptions = isCaseSensitive ? 0 : NSRegularExpressionCaseInsensitive;

  NSString *placeholder = isWholeWords ? @"\\b%@\\b" : @"%@";
  NSString *pattern = [NSString stringWithFormat:placeholder, string];

  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:regexOptions error:&error];
  if (error)
  {
    NSLog(@"Couldn't create regex with given string and options");
  }

  return regex;
}

+ (NSArray *)captureString:(NSString *)str withRegex:(NSString *)regexStr
{
  NSRegularExpression *regex = [WTUtils regularExpressionWithString:regexStr
                                                            options:nil];

  NSArray *matches = [regex matchesInString:str
                                    options:NSMatchingProgress
                                      range:NSMakeRange(0, str.length)];


  NSArray *result = [matches map:^id (NSTextCheckingResult *m)
  {
    NSString *s = [str substringWithRange:[m rangeAtIndex:1]];
    return s;
  }];
  return result;
}
@end


@implementation NSString (MD5)

- (NSString *)md5
{
  const char      *concat_str = [self UTF8String];
  unsigned char   result[CC_MD5_DIGEST_LENGTH];

  CC_MD5(concat_str, strlen(concat_str), result);
  NSMutableString *hash = [NSMutableString string];

  for (int i = 0; i < 16; i++) {
    [hash appendFormat:@"%02X", result[i]];
  }

  return [hash lowercaseString];
}

@end


@implementation NSDate (BNKit)

- (NSString *)stringWithFormat:(NSString *)format
{
  if ([self isEqual:@""])
  {
    return @"";
  }
  NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
  [outputFormatter setDateFormat:format];
  NSString *timestamp_str = [outputFormatter stringFromDate:self];
  return timestamp_str;
}

+ (NSDate *)firstDayOfMonth
{
  NSInteger n = [[NSDate date] numberOfDaysInMonthCount];
  NSInteger ago = n * 60 * 60 * 24;
  NSDate *lastDay = [self lastDayOfMonth];
  NSDate *firstDay = [NSDate dateWithTimeIntervalSince1970:lastDay.timeIntervalSince1970 - ago];
  return firstDay;
}

+ (NSDate *)lastDayOfMonth
{
  NSDate *now = [NSDate date];
  NSInteger dayCount = [now numberOfDaysInMonthCount];

  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

  [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];

  NSDateComponents *comp = [calendar components:
          NSYearCalendarUnit |
                  NSMonthCalendarUnit |
                  NSDayCalendarUnit    fromDate:now];

  [comp setDay:dayCount];

  return [calendar dateFromComponents:comp];
}

- (NSInteger)numberOfDaysInMonthCount
{
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

  [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];

  NSRange dayRange = [calendar rangeOfUnit:NSDayCalendarUnit
                                    inUnit:NSMonthCalendarUnit
                                   forDate:self];

  return dayRange.length;
}

+ (NSDate *)dateFromString:(NSString *)string
{
  return [NSDate dateFromString:string withFormat:[NSDate dbFormatString]];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format
{
  NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
  [inputFormatter setDateFormat:format];
  NSDate *date = [inputFormatter dateFromString:string];
  return date;
}

+ (NSString *)dateFormatString
{
  return @"yyyy-MM-dd";
}

+ (NSString *)timeFormatString
{
  return @"HH:mm:ss";
}

+ (NSString *)timestampFormatString
{
  return @"yyyy-MM-dd HH:mm:ss";
}

// preserving for compatibility
+ (NSString *)dbFormatString
{
  return [NSDate timestampFormatString];
}

@end


