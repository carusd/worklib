//
//  UIImage+load.m
//  iGuitar
//
//  Created by carusd on 14-7-20.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "UIImage+load.h"

@implementation UIImage (load)

+ (UIImage *)imageWithKey:(NSString *)imageKey {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], imageKey];
    
    return [UIImage imageWithContentsOfFile:path];
}


#warning I'll come back to u later
inline UIImage * imageWithKey(NSString *imageKey) {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], imageKey];
    
    return [UIImage imageWithContentsOfFile:path];
}

+ (UIImage *)imageWithKey:(NSString *)imageKey strategy:(GTImageLoadingStrategy)strategy {
    if (GTImageLoadingStrategyCacheInMemory == strategy) {
        return [UIImage imageWithKey:imageKey];
    } else if (GTImageLoadingStrategyFromDisk == strategy) {
        return [[UIImage imageNamed:imageKey] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        return [UIImage imageWithKey:imageKey];
    }
}

@end
