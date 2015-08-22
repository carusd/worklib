//
//  NSString+uriencode.h
//  iGuitar
//
//  Created by carusd on 14/11/5.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (uriencode)

- (NSString *)encodeURIComponent;
- (NSString *)decodeURIComponent;
@end
