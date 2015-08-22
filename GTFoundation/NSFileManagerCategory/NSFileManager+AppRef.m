//
//  NSFileManager+AppRef.m
//  iGuitar
//
//  Created by carusd on 14-8-20.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "NSFileManager+AppRef.h"

@implementation NSFileManager (AppRef)

NSString *_appRootPath = nil;

+ (NSString *)documentDirectoryPath {
    return ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]);
}

+ (NSString *)appRootPath {
    [NSFileManager ensureAppRootPath];
    return _appRootPath;
}

+ (void)ensureAppRootPath {
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *appSupport = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES)[0];
        
        NSString *path = [NSString stringWithFormat:@"%@/%@", appSupport, AppRoot];
        if (![fileManager fileExistsAtPath:path]) {
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        _appRootPath = path;
        
    });
    
}

@end
