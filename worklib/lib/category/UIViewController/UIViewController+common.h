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

@property (nonatomic) BOOL forceRefresh;

// debug
- (void)openDebugViewController;
- (void)openConsoleController;

- (void)setBackBtnWithImg:(UIImage *)image;
- (void)setBarBackBtnWithImg:(UIImage *)image;

- (void)setLeftBarView:(UIView *)leftBarView;
- (void)setRightBarView:(UIView *)rightBarView;

// loading
@property (nonatomic, strong) GTLoadingView *loadingView;

- (void)setupLoadingView;
- (void)showLoading;
- (void)hideLoading;



@property (nonatomic, readonly) UIView *emptyDataIndicatorContainer;
- (void)setupEmptyDataIndicator:(UIView *)view customLayout:(BOOL)custom;
- (void)didTapEmptyDataIndicator;
@end
