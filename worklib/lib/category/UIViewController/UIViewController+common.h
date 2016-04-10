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


// debug
- (void)openDebugViewController;
- (void)openConsoleController;

- (void)setBackBtnWithImg:(UIImage *)image;
- (void)setLeftBarView:(UIView *)leftBarView;
- (void)setRightBarView:(UIView *)rightBarView;

// loading
- (void)setupLoadingView;
- (void)showLoading;
- (void)hideLoading;

@end
