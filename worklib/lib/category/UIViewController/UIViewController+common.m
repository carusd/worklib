//
//  UIViewController+common.m
//  Pods
//
//  Created by carusd on 16/4/8.
//
//

#import "UIViewController+common.h"
#import "GTConsoleViewController.h"
#import "GTDebugViewController.h"
#import "GTLoadingView.h"
//#import <ReactiveCocoa/UIControl+RACSignalSupport.h>
//#import "UIControl+RACSignalSupport.h"
//#import "RACSignal.h"
#import <objc/runtime.h>

NSString * const loadingViewPropertyKey = @"loadingViewPropertyKey";

@interface UIViewController ()



@end

@implementation UIViewController (common)
@dynamic loadingView;

- (void)setLoadingView:(GTLoadingView *)loadingView {
    objc_setAssociatedObject(self, (__bridge const void *)loadingViewPropertyKey, loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GTLoadingView *)loadingView {
    return objc_getAssociatedObject(self, (__bridge const void *)(loadingViewPropertyKey));
}

- (BOOL)isRootViewController {
    return (self.navigationController.viewControllers.firstObject == self);
}

+ (UIWindow *)window {
    return [UIApplication sharedApplication].windows[0];
}


#pragma mark debug
- (void)openDebugViewController {
    GTDebugViewController *debug = [[GTDebugViewController alloc] init];
    [self presentViewController:debug animated:YES completion:nil];
}

- (void)openConsoleController {
    GTConsoleViewController *console = [[GTConsoleViewController alloc] init];
    [self presentViewController:console animated:YES completion:nil];
}


#pragma mark top bar
- (void)setBackBtnWithImg:(UIImage *)image {
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 44, 44);
    
    [back setImage:image forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self setLeftBarView:back];
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setLeftBarView:(UIView *)leftBarView {
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBarView];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                               target:nil action:nil];
    spacer.width = -11;
    
    self.navigationItem.leftBarButtonItems = @[spacer, leftBarButton];
}

- (void)setRightBarView:(UIView *)rightBarView {
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightBarView];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                               target:nil action:nil];
    spacer.width = -11;
    
    self.navigationItem.rightBarButtonItems = @[rightBarButton, spacer];
}

#pragma mark loading
- (void)setupLoadingView {
    self.loadingView = [[GTLoadingView alloc] init];
    self.loadingView.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) / 2);
    self.loadingView.hidden = YES;
    [self.view addSubview:self.loadingView];
    
    self.loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.loadingView addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100]];
    [self.loadingView addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100]];
    
    [self.view layoutIfNeeded];
}

- (void)showLoading {
    self.loadingView.hidden = NO;
    [self.view bringSubviewToFront:self.loadingView];
    [self.loadingView.indicatorView startAnimating];
}

- (void)hideLoading {
    [self.loadingView.indicatorView stopAnimating];
    self.loadingView.hidden = YES;
}

@end
