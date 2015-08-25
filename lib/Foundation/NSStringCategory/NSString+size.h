//
//  NSString+size.h
//  iGuitar
//
//  Created by carusd on 14-7-26.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (size)

- (CGSize)sizeWithConstrainedSize:(CGSize)size font:(UIFont *)font;

@end
