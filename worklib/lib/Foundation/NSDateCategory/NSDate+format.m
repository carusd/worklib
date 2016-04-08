//
//  NSDate+format.m
//  iGuitar
//
//  Created by carusd on 14-8-30.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "NSDate+format.h"

@implementation NSDate (format)

+ (NSString *) getDateFormatYYYYMMDDHHmmssWithDatePC:(NSDate *) date{
    NSDateFormatter *customDateFormatter = [[NSDateFormatter alloc] init];
    [customDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return  [customDateFormatter stringFromDate:date];
}

+ (NSString *) getDateFormatYYYYMMDDHHmmWithDatePC:(NSDate *) date{
    NSDateFormatter *customDateFormatter = [[NSDateFormatter alloc] init];
    [customDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return  [customDateFormatter stringFromDate:date];
}

+ (NSString *) getDateFormatYYYYMMDDWithDatePC:(NSDate *) date{
    NSDateFormatter *customDateFormatter = [[NSDateFormatter alloc] init];
    [customDateFormatter setDateFormat:@"yyyy-MM-dd"];
    return  [customDateFormatter stringFromDate:date];
}

+ (NSString *) getCurrentDateWithFormatYYYYMMDDPC{
    NSDateFormatter *customDateFormatter = [[NSDateFormatter alloc] init];
    [customDateFormatter setDateFormat:@"yyyyMMdd"];
    return  [customDateFormatter stringFromDate:[NSDate date]];
}

+ (NSInteger) getCurrentTimezoneWithInt {
    NSInteger secondsFromGMT = [NSTimeZone systemTimeZone].secondsFromGMT;
    return secondsFromGMT%3600==0?secondsFromGMT/3600:secondsFromGMT/3600>0?secondsFromGMT/3600+1:secondsFromGMT/3600-1;
}

+ (NSDate *)localDate
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    return [date dateByAddingTimeInterval:[zone secondsFromGMTForDate:date]];
}
@end
