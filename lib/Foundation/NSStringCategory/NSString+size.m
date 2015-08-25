//
//  NSString+size.m
//  iGuitar
//
//  Created by carusd on 14-7-26.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "NSString+size.h"
#import "GTMacros.h"
#import "GTConstants.h"

@implementation NSString (size)

- (CGSize)sizeWithConstrainedSize:(CGSize)size font:(UIFont *)font {
    CGSize result;
    if (GTIOSVersion >= 7) {
        CGSize tmp = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
        result = CGSizeMake(ceil(tmp.width), ceil(tmp.height));
    } else {
        result = [self sizeWithFont:font constrainedToSize:size];
    }
    
    return result;
}

@end
