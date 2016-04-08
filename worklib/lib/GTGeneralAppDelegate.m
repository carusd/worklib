//
//  GTGeneralAppDelegate.m
//  iGuitar
//
//  Created by carusd on 14-8-30.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "GTGeneralAppDelegate.h"
#import "NSDate+format.h"
#import "GTConstants.h"

@implementation GTGeneralAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    [self.window makeKeyAndVisible];
    
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
#warning fixme 下个版本再做详细的
//        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
//        action.identifier = @"action";//按钮的标示
//        action.title=@"Accept";//按钮的标题
//        action.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
//        //    action.authenticationRequired = YES;
//        //    action.destructive = YES;
//        
//        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
//        action2.identifier = @"action2";
//        action2.title=@"Reject";
//        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
//        action.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
//        action.destructive = YES;
//        
//        //2.创建动作(按钮)的类别集合
//        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
//        categorys.identifier = @"alert";//这组动作的唯一标示,推送通知的时候也是根据这个来区分
//        [categorys setActions:@[action,action2] forContext:(UIUserNotificationActionContextMinimal)];
        
        //3.创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:notiSettings];
    } else {
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    }
    
    //处理启动参数
    if (launchOptions){
        //处理推送打开的参数
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo) {
            [self pushNotificationOpen:userInfo];
        }
        
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

- (void)pushNotificationOpen:(NSDictionary *)userInfo
{
    NSString *open = [userInfo objectForKey:@"open"];
    if (open) {
        [self remotePushNotifactionOpen:open];
    }
    NSString *update = [userInfo objectForKey:@"update"];
    if (update) {
        [self remotePushNotifactionUpdate:update];
    }
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

//子类必须实现，处理逻辑
- (void) remotePushNotifactionOpen:(NSString *) open
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
