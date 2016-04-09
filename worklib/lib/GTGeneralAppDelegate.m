//
//  GTGeneralAppDelegate.m
//  iGuitar
//
//  Created by carusd on 14-8-30.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "GTGeneralAppDelegate.h"

@implementation GTGeneralAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // 4m for memory , 20m for disk
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    //检查安装与应用更新，及执行相应的代码
    [self checkFirstLaunched];
    [self checkAppUpgrade];
    
    
    
    //启用推送
    if (GTIOSVersion >= 8) {
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:notiSettings];
    } else {
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    }
    
    
    return YES;
}



#pragma mark -
#pragma mark 检查安装与应用更新，及执行相应的代码
- (void) checkFirstLaunched
{
    NSString *installDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"install_date"];
    if (installDate != nil) {
        return;
    }
    NSString *current_app_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [self appInstallRunOnce:current_app_version];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate getCurrentDateWithFormatYYYYMMDDPC] forKey:@"install_date"];
    
}

- (void) checkAppUpgrade
{
    NSString *last_app_version = [[NSUserDefaults standardUserDefaults] objectForKey:@"app_version"];
    NSString *current_app_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    if (current_app_version != nil && [current_app_version isEqualToString:last_app_version]) {
        return;
    }
    
    [self appUpgradeRunOnce:current_app_version previousVer:last_app_version];
    
    [[NSUserDefaults standardUserDefaults] setObject:current_app_version forKey:@"app_version"];
    
}


#pragma mark -
#pragma mark 子类需要重写的方法
//App安装后第一次启动时执行的代码,主线程中执行（如果有需要）
//currentVer:当前版本号
- (void) appInstallRunOnce:(NSString *)currentVer
{
    
}

//App版本升级后第一次的兼容代码,主线程中执行（如果有需要）
//currentVer:当前版本号
//previousVer:升级前版本号
- (void) appUpgradeRunOnce:(NSString *)currentVer previousVer:(NSString *)previousVer
{
    
}


//如有特殊需求子类可重载
- (void) remotePushNotifactionUpdate:(NSString *) updateUrl
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:updateUrl]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
    }
}

@end
