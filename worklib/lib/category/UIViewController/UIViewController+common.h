//
//  UIViewController+common.h
//  Pods
//
//  Created by carusd on 16/4/8.
//
//

#import <UIKit/UIKit.h>
#import "GTLoadingView.h"

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
@property (nonatomic, strong) GTLoadingView *loadingView;

- (void)setupLoadingView;
- (void)showLoading;
- (void)hideLoading;

@end
