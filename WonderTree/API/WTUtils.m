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
