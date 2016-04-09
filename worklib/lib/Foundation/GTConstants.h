//
//  GTConstants.h
//  iGuitar
//
//  Created by carusd on 14-6-4.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#ifndef iGuitar_GTConstants_h
#define iGuitar_GTConstants_h


// 设备相关
#define GTDeviceWidth ([[UIScreen mainScreen] bounds].size.width)
#define GTDeviceHeight ([UIScreen mainScreen].bounds.size.height)

#define GTCenterAtWindow (CGPointMake(GTDeviceWidth / 2, GTDeviceHeight / 2))

#define GTIOSVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

#endif
