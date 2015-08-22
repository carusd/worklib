//
//  GTTabBarController.m
//  iGuitar
//
//  Created by carusd on 15/7/16.
//  Copyright (c) 2015年 GuitarGG. All rights reserved.
//

#import "GTTabBarController.h"
#import "UIImage+load.h"
#import "GTNavigationController.h"

@interface GTTabBarController ()

@end

@implementation GTTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    static NSArray *images = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        images = @[@"tabbar_moment_selected", @"tabbar_video_selected", @"", @"tabbar_master_selected", @"tabbar_me_selected"];
    });
    for (NSInteger i=0; i<self.viewControllers.count; i++) {
        UIViewController *viewController = self.viewControllers[i];
        viewController.tabBarItem.selectedImage = [[UIImage imageNamed:images[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:GTMainColor, NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: GTMainColor}];
    
    UIImageView *plusImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithKey:@"tabbar_publish_selected.png" strategy:GTImageLoadingStrategyFromDisk]];
    plusImageView.center = CGPointMake(GTDeviceWidth / 2, 20);
    [self.tabBar addSubview:plusImageView];
}


#pragma mark tabbar controller delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    
    if ([self.viewControllers indexOfObject:viewController] == 2) {
        
        UIStoryboard *publishMomentStoryboard = [UIStoryboard storyboardWithName:@"GTPublishMoment" bundle:nil];
        GTNavigationController *publishMomentNav = [publishMomentStoryboard instantiateInitialViewController];
        
        [self presentViewController:publishMomentNav animated:YES completion:nil];
        return NO;
    }
    
    return YES;
}

@end
