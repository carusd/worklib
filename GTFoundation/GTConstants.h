//
//  GTConstants.h
//  iGuitar
//
//  Created by carusd on 14-6-4.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#ifndef iGuitar_GTConstants_h
#define iGuitar_GTConstants_h

// 文件目录
#define AppRoot @"com.iguitar.gg"

// 设备相关
#define GTDeviceWidth ([[UIScreen mainScreen] bounds].size.width)
#define GTDeviceHeight ([UIScreen mainScreen].bounds.size.height) // ios7返回了568， ios6返回了548，如果编译的sdk低于ios7，可能会更复杂
#define GTIOSVersion ([[[UIDevice currentDevice] systemVersion] floatValue])
#define GTAppContentHeight() (GTDeviceHeight)
#define GTAppContentStartAt() (20)
#define GTNavigationBarHeight() (64)
#define GTCenterAtWindow (CGPointMake(GTDeviceWidth/2, GTDeviceHeight/2))



#define GTVideoStrategyKey (@"GTVideoStrategyKey")
#endif
