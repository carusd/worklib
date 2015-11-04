//
//  NSString+timestamp.m
//  iGuitar
//
//  Created by carusd on 14-7-26.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "NSString+timestamp.h"
#import "NSDate+timestamp.h"

@implementation NSString (timestamp)
+ (NSString *)transformDateTime:(NSTimeInterval)time
{
    return [self transformDateTime:time withFormate:@"yyyy-MM-dd"];
}

+ (NSString *)transformDateTime:(NSTimeInterval)time withFormate:(NSString *)formate
{
    NSDate *now = [NSDate date];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSTimeInterval dateDif = [now timeIntervalSinceDate:date];
    if (dateDif < 60)
    {
//        return [NSString stringWithFormat:@"%d秒前", (int)fmaxf(dateDif, 0)];
        return @"刚刚";
    }
    else if (dateDif < 900) {
        int minute = dateDif / 60;
        return [NSString stringWithFormat:@"%d分钟前", minute];
    } else if (dateDif >= 900 && dateDif <= 1800) {
        return @"半小时前";
    } else if (dateDif > 1800 && dateDif <= 3600) {
        return @"1小时前";
    } else if (dateDif > 3600 && dateDif <= 3600*24) {
        int hour = dateDif / 3600;
        return [NSString stringWithFormat:@"%d小时前", hour];
    } else if (dateDif > 3600*24 && dateDif <= 3600*48) {
        return @"昨天";
    } else if (dateDif > 3600*48 && dateDif <= 3600*72) {
        return @"前天";
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:formate];
        NSString *formatterStr = [formatter stringFromDate:date];
        return formatterStr;
    }
}

- (NSDate *)dateFromString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:self];
    
    //    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //
    //    NSInteger interval = [zone secondsFromGMTForDate:destDate];
    //
    //    NSDate *localeDate = [destDate dateByAddingTimeInterval:interval];
    
    return destDate;
    
}

- (NSString *)timeFromDate:(NSDate *)aDate {
    //    NSLog(@"original time ----->: %@", self);
    NSDate *creatTime = [self dateFromString];
    
    NSTimeInterval timeBetweenSomeDateAndCreat = [aDate timeIntervalSinceDate:creatTime];
    
    NSDate *today = [[NSDate today] addTimeZone];
    NSTimeInterval timeBetweenTodayAndCreat = [today timeIntervalSinceDate:creatTime];
    
    NSTimeInterval refTimeInterval;
    
    NSString *timeStr = nil;
    if (timeBetweenTodayAndCreat <= 0) {
        // 当天
        refTimeInterval = timeBetweenSomeDateAndCreat;
        
        if ((int)(refTimeInterval / 60) == 0) {
            //刚刚
            timeStr = @"刚刚";
        }else if (refTimeInterval / 60 / 60 < 1) {
            //小于1小时
            timeStr = [NSString stringWithFormat:@"%d分钟前", (int)(refTimeInterval / 60)];
        }else if(refTimeInterval / 60 / 60 / 24 < 1)
        {
            //小于1天
            timeStr = [NSString stringWithFormat:@"%d小时前", (int)(refTimeInterval / 60 / 60)];
        } else {
            timeStr = self.description;
        }
    } else {
        // 跨天
        refTimeInterval = fabsf(timeBetweenTodayAndCreat);
        
        if(refTimeInterval / 60 / 60 / 24 < 1)
        {
            //小于1天
            timeStr = @"昨天";
        }else if(refTimeInterval / 60 / 60 / 24 < 7){
            //大于1天 小于7天
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat: @"MM-dd"];
            timeStr = [dateFormatter stringFromDate:creatTime];
        }else{
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            timeStr = [dateFormatter stringFromDate:creatTime];
        }
    }
    //    NSLog(@"result ----->: %@", timeStr);
    return timeStr;
}
@end
