//
//  GTLocation.h
//  iGuitar
//
//  Created by carusd on 15/10/12.
//  Copyright (c) 2015年 GuitarGG. All rights reserved.
//


extern NSString * const GTLocationResultNotif;


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GTLocation : NSObject <CLLocationManagerDelegate>

// 单例，获取单例不会启动定位，必须执行startUp来获得位置
+ (instancetype)sharedInstance;

// startUp会执行初始化行为，其中也包含获取位置
- (void)startUp;

// 获取位置
- (void)getLocation;

@property (nonatomic, readonly) double longitude;
@property (nonatomic, readonly) double latitude;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, readonly) BOOL ready;

@end
