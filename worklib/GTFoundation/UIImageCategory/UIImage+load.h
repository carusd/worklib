//
//  UIImage+load.h
//  iGuitar
//
//  Created by carusd on 14-7-20.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GTImageLoadingStrategyCacheInMemory,
    GTImageLoadingStrategyFromDisk
} GTImageLoadingStrategy;

@interface UIImage (load)

+ (UIImage *)imageWithKey:(NSString *)imageKey;
+ (UIImage *)imageWithKey:(NSString *)imageKey strategy:(GTImageLoadingStrategy)strategy;

@end
