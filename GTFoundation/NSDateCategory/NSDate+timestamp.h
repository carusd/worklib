//
//  NSDate+timestamp.h
//  iGuitar
//
//  Created by carusd on 14-8-30.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (timestamp)

+ (NSDate *)today;
- (NSDate *)addTimeZone;

@end
