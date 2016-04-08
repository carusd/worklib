//
//  NSDate+timestamp.m
//  iGuitar
//
//  Created by carusd on 14-8-30.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "NSDate+timestamp.h"

@implementation NSDate (timestamp)

+ (NSDate *)today
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    //        NSLog(@"components: %@", components);
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0];
    
    return today;
}


- (NSString *)weekString
{
    NSDate *dateAfterZone = [self addTimeZone];
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSWeekdayCalendarUnit fromDate:dateAfterZone];
    NSInteger weekday = [componets weekday];
    NSString *weekStr = @"";
    switch (weekday) {
        case 1:
            weekStr = @"星期日";
            break;
        case 2:
            weekStr = @"星期一";
            break;
        case 3:
            weekStr = @"星期二";
            break;
        case 4:
            weekStr = @"星期三";
            break;
        case 5:
            weekStr = @"星期四";
            break;
        case 6:
            weekStr = @"星期五";
            break;
        case 7:
            weekStr = @"星期六";
            break;
        default:
            break;
    }
    NSLog(@"weekStr: %@", weekStr);
    return weekStr;
}

- (NSString *)moothAndDayString
{
    NSDate *dateAfterZone = [self addTimeZone];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *comps = [[NSCalendar autoupdatingCurrentCalendar] components:unitFlags fromDate:dateAfterZone];
    
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSString *returnStr = [NSString stringWithFormat:@"%ld月%ld日", (long)month, day];
    NSLog(@"moonth dateAfterZone: %@", dateAfterZone);
    NSLog(@"returnStr: %@", returnStr);
    
    return returnStr;
}



- (NSDate *)addTimeZone
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate:self];
    
    NSDate *localeDate = [self dateByAddingTimeInterval:interval];
    
    return localeDate;
}



@end
