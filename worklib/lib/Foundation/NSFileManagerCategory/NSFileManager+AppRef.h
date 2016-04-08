//
//  NSFileManager+AppRef.h
//  iGuitar
//
//  Created by carusd on 14-8-20.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (AppRef)

+ (NSString *)documentDirectoryPath;
+ (NSString *)appRootPath;
@end
