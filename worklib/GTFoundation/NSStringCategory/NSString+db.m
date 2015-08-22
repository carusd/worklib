//
//  NSString+db.m
//  iGuitar
//
//  Created by carusd on 14-8-30.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "NSString+db.h"

@implementation NSString (db)

+ (NSString *)questionMarkStringWithCount:(int)count {
    NSMutableString *s = [[NSMutableString alloc] initWithString:@"("];
    
    @try {
        for (int i=0; i<count; i++) {
            [s appendString:@"?,"];
        }
        [s deleteCharactersInRange:NSMakeRange(s.length-1, 1)];
        [s appendString:@")"];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        return [s copy];
    }
}

@end
