//
//  NSString+timestamp.h
//  iGuitar
//
//  Created by carusd on 14-7-26.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (timestamp)
+ (NSString *)transformDateTime:(NSTimeInterval)time;
+ (NSString *)transformDateTime:(NSTimeInterval)time withFormate:(NSString *)formate;
@end
