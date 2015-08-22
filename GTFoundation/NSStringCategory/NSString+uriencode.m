//
//  NSString+uriencode.m
//  iGuitar
//
//  Created by carusd on 14/11/5.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "NSString+uriencode.h"

@implementation NSString (uriencode)

- (NSString *)encodeURIComponent
{
    NSString *result = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                            kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            NULL,
                                            CFSTR("!*'();:@&=+$,/?%#[] "),
                                            kCFStringEncodingUTF8));
    return result;
}

- (NSString *)decodeURIComponent
{
    NSString *result = (NSString *)
    CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                            kCFAllocatorDefault,
                                                            (CFStringRef)self,
                                                            CFSTR(""),
                                                            kCFStringEncodingUTF8));
    return result;
}

@end
