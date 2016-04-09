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

@interface UIViewController ()

@property (nonatomic, strong) GTLoadingView *loadingView;

@end

@implementation UIViewController (common)


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
