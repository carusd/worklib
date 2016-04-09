//
//  UIViewController+common.h
//  Pods
//
//  Created by carusd on 16/4/8.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (common)

- (BOOL)isRootViewController;

+ (UIWindow *)window;


#pragma mark debug
- (void)openDebugViewController;
- (void)openConsoleController;

// loading
- (void)setupLoadingView;
- (void)showLoading;
- (void)hideLoading;

@end
