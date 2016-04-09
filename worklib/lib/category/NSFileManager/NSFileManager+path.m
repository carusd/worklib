//
//  NSFileManager+path.m
//  iGuitar
//
//  Created by carusd on 16/4/10.
//  Copyright © 2016年 GuitarGG. All rights reserved.
//

#import "NSFileManager+path.h"

@implementation NSFileManager (path)

+ (NSString *)documentDirectoryPath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, NO).firstObject;
    
    return path;
    
}

@end
