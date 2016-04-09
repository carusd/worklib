//
//  UIColor+Text.m
//  iGuitar
//
//  Created by carusd on 14-7-2.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "UIColor+Text.h"
#import "GTMacros.h"

@implementation UIColor (Text)

+ (UIColor *)gtBlackColor {
    return GTColor(51, 51, 51, 1);
}

+ (UIColor *)gtWhiteColor {
    return [UIColor whiteColor];
}

+ (UIColor *)gtMainColor {
    return GTColor(236, 127, 7, 1);
}

@end
