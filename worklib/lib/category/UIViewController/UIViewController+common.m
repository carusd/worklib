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
#import <objc/runtime.h>


@interface UIViewController ()

@property (nonatomic, strong) UIView *emptyDataIndicatorContainer;

@end

@implementation UIViewController (common)
@dynamic loadingView;

- (void)setLoadingView:(GTLoadingView *)loadingView {
    objc_setAssociatedObject(self, (__bridge const void *)@"loadingView", loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GTLoadingView *)loadingView {
    return objc_getAssociatedObject(self, (__bridge const void *)(@"loadingView"));
}

- (void)setForceRefresh:(BOOL)forceRefresh {
    objc_setAssociatedObject(self, (__bridge const void *)@"forceRefresh", @(forceRefresh), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)forceRefresh {
    return objc_getAssociatedObject(self, (__bridge const void *)(@"forceRefresh"));
}

- (void)setEmptyDataIndicatorContainer:(UIView *)container {
    objc_setAssociatedObject(self, (__bridge const void *)@"emptyDataIndicatorContainer", container, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)emptyDataIndicatorContainer {
    return objc_getAssociatedObject(self, (__bridge const void *)(@"emptyDataIndicatorContainer"));
}


- (void)setupEmptyDataIndicator:(UIView *)view customLayout:(BOOL)custom{
    assert(view);
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.emptyDataIndicatorContainer = [UIView new];
    self.emptyDataIndicatorContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.emptyDataIndicatorContainer];
    
    UIView *container = self.emptyDataIndicatorContainer;
    NSDictionary *views = NSDictionaryOfVariableBindings(container, view);
    
    if (!custom) {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[container]|" options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[container]|" options:0 metrics:nil views:views]];
    }
    
    
    [container addSubview:view];
    
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:views]];
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:views]];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapEmptyDataIndicator:)];
    [self.emptyDataIndicatorContainer addGestureRecognizer:tap];
    
    self.emptyDataIndicatorContainer.hidden = YES;
}

- (void)didTapEmptyDataIndicator {
    
}

- (void)handleTapEmptyDataIndicator:(UITapGestureRecognizer *)tap {
    [self didTapEmptyDataIndicator];
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
    back.frame = CGRectMake(20, 20, 44, 44);
    
    [back setImage:image forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:back];
    
}

- (void)setBarBackBtnWithImg:(UIImage *)image {
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
