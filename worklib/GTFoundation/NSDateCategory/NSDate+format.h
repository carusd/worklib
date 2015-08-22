//
//  NSDate+format.h
//  iGuitar
//
//  Created by carusd on 14-8-30.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (format)

/**
 返回指定日期的yyyy-MM-dd HH:mm:ss格式
 @param  date 日期类
 @returns 返回指定日期的yyyy-MM-dd HH:mm:ss格式
 */
+ (NSString *) getDateFormatYYYYMMDDHHmmssWithDatePC:(NSDate *) date;//yyyy-MM-dd HH:mm:ss

//yyyy-MM-dd HH:mm
+ (NSString *) getDateFormatYYYYMMDDHHmmWithDatePC:(NSDate *) date;

//yyyy-MM-dd
+ (NSString *) getDateFormatYYYYMMDDWithDatePC:(NSDate *) date;
/**
 返回当前时间的yyyyMMdd格式
 @returns 返回当前时间的yyyyMMdd格式
 */
+ (NSString *) getCurrentDateWithFormatYYYYMMDDPC;
/**
 返回当前时区
 @returns 返回当前时区
 */
+ (NSInteger) getCurrentTimezoneWithInt;

+ (NSDate *)localDate;
@end
