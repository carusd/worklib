//
//  GTViewController.m
//  iGuitar
//
//  Created by carusd on 14-5-2.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "GTViewController.h"
#import "GTDebugViewController.h"
#import "GTConsoleViewController.h"

@interface GTViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) GTLoadingView *loadingView;
@property (nonatomic) NSInteger modelId;
@property (nonatomic, strong) NSDictionary *ext;
@property (nonatomic, strong) UIView *navBar;
@end


@implementation GTViewController
- (id)initWithModelId:(NSInteger)modelId ext:(NSDictionary *)ext {
    self = [super init];
    if (self) {
        self.modelId = modelId;
        self.ext = ext;
    }
    
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"vvvvvvvvvvvvv  %@", NSStringFromClass([self class]));
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.openDebugGestureReg = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openDebugViewController)];
    self.openDebugGestureReg.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.openDebugGestureReg];
    
    self.openConsoleGestureReg = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openConsoleController)];
    self.openConsoleGestureReg.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.openConsoleGestureReg];
    
    
    self.loadingView = [[GTLoadingView alloc] init];
    self.loadingView.center = CGPointMake(GTView_W(self.view) / 2, GTAppContentHeight() / 2);
    self.loadingView.hidden = YES;
    [self.view addSubview:self.loadingView];
    
    self.loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.loadingView addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100]];
    [self.loadingView addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100]];
    
    [self.view layoutIfNeeded];
    
    
}



- (void)openDebugViewController {
    GTDebugViewController *debug = [[GTDebugViewController alloc] init];
    [self presentViewController:debug animated:YES completion:nil];
}

- (void)openConsoleController {
    GTConsoleViewController *console = [[GTConsoleViewController alloc] init];
    [self presentViewController:console animated:YES completion:nil];
}

#pragma mark loading
- (void)showLoading {
    self.loadingView.hidden = NO;
    [self.view bringSubviewToFront:self.loadingView];
    [self.loadingView.indicatorView startAnimating];
}

- (void)hideLoading {
    [self.loadingView.indicatorView stopAnimating];
    self.loadingView.hidden = YES;
}

#pragma mark bar 
- (void)setupNavBar {
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GTView_W(self.view), 64)];
    self.navBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navBar];
    self.navBar.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *views = NSDictionaryOfVariableBindings(_navBar);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_navBar]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_navBar(64)]" options:0 metrics:nil views:views]];
    
    [self.view layoutIfNeeded];
    
}

- (void)setBarTitle:(NSString *)barTitle {
    static const NSString *barTitleTagStr = @"barTitle";
    UILabel *barTitleLabel_ = (UILabel *)[self.view viewWithTag:barTitleTagStr.hash];
    if (barTitleLabel_) {
        barTitleLabel_.text = barTitle;
    } else {
        UILabel *barTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 200, 44)];
        barTitleLabel.backgroundColor = [UIColor clearColor];
        barTitleLabel.text = barTitle;
        barTitleLabel.tag = barTitleTagStr.hash;
        barTitleLabel.textAlignment = NSTextAlignmentCenter;
        barTitleLabel.font = [UIFont boldSystemFontOfSize:20];
        barTitleLabel.textColor = [UIColor whiteColor];
        barTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(barTitleLabel);
        
        if (self.navBar) {
            [self.navBar addSubview:barTitleLabel];
            
            [self.navBar addConstraint:[NSLayoutConstraint constraintWithItem:self.navBar attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:barTitleLabel attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
            [self.navBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[barTitleLabel(44)]" options:0 metrics:nil views:views]];
        } else {
            [self.view addSubview:barTitleLabel];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:barTitleLabel attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[barTitleLabel(44)]" options:0 metrics:nil views:views]];
        }
        
        [self.view layoutIfNeeded];
    }
}

- (UIView *)barTitleView {
    static const NSString *barTitleViewStr = @"barTitleViewStr";
    return [self.view viewWithTag:barTitleViewStr.hash];
}

- (void)setBarTitleView:(UIView *)barTitleView {
    static const NSString *barTitleViewStr = @"barTitleViewStr";
    UIView *barTitleView_ = [self.view viewWithTag:barTitleViewStr.hash];
    if (barTitleView_) {
        [barTitleView_ removeFromSuperview];
    }
    barTitleView.tag = barTitleViewStr.hash;
    barTitleView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(barTitleView);
    
    if (self.navBar) {
        [self.navBar addSubview:barTitleView];
        
        [self.navBar addConstraint:[NSLayoutConstraint constraintWithItem:self.navBar attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:barTitleView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.navBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[barTitleView(44)]" options:0 metrics:nil views:views]];
    } else {
        [self.view addSubview:barTitleView];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:barTitleView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[barTitleView(44)]" options:0 metrics:nil views:views]];
    }
    
    [self.view layoutIfNeeded];
}

- (void)setLeftBarButton:(UIButton *)leftBarButton {
    static const NSString *leftTagStr = @"leftBarButton";
    UIView *leftBarButton_ = [self.view viewWithTag:leftTagStr.hash];
    if (leftBarButton_) {
        [leftBarButton_ removeFromSuperview];
    }
    
    leftBarButton.tag = leftTagStr.hash;
    leftBarButton.frame = CGRectMake(10, 20, 50, 44);
    leftBarButton.backgroundColor = [UIColor clearColor];
    leftBarButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(leftBarButton);
    
    if (self.navBar) {
        [self.navBar addSubview:leftBarButton];
        
        [self.navBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[leftBarButton(50)]" options:0 metrics:nil views:views]];
        [self.navBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[leftBarButton(44)]" options:0 metrics:nil views:views]];
    } else {
        [self.view addSubview:leftBarButton];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[leftBarButton(50)]" options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[leftBarButton(44)]" options:0 metrics:nil views:views]];
    }
    
    [self.view layoutIfNeeded];
}

- (UIButton *)leftBarButton {
    static const NSString *leftTagStr = @"leftBarButton";
    return (UIButton *)[self.view viewWithTag:leftTagStr.hash];
}

- (void)setRightBarButton:(UIButton *)rightBarButton {
    static const NSString *rightTagStr = @"rightBarButton";
    UIView *rightBarButton_ = [self.view viewWithTag:rightTagStr.hash];
    if (rightBarButton_) {
        [rightBarButton_ removeFromSuperview];
    }
    
    rightBarButton.tag = rightTagStr.hash;
    rightBarButton.frame = CGRectMake(260, GTAppContentStartAt(), 50, 44);
    rightBarButton.backgroundColor = [UIColor clearColor];
    rightBarButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(rightBarButton);
    
    
    if (self.navBar) {
        [self.navBar addSubview:rightBarButton];
        
        [self.navBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[rightBarButton]-10-|" options:0 metrics:nil views:views]];
        [self.navBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[rightBarButton(44)]" options:0 metrics:nil views:views]];
    } else {
        [self.view addSubview:rightBarButton];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[rightBarButton]-10-|" options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[rightBarButton(44)]" options:0 metrics:nil views:views]];
    }
    
    
    [self.view layoutIfNeeded];
    
}

- (UIButton *)rightBarButton {
    static const NSString *rightTagStr = @"rightBarButton";
    return (UIButton *)[self.view viewWithTag:rightTagStr.hash];
}

- (void)setDetaultBackButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageWithKey:@"icon_back_white.png"] forState:UIControlStateNormal];
    
    [self setLeftBarButton:button];
}

- (void)setWhiteBackButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageWithKey:@"icon_back_white.png"] forState:UIControlStateNormal];
    
    [self setLeftBarButton:button];
}

- (void)setBlackBackButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageWithKey:@"icon_back.png"] forState:UIControlStateNormal];
    
    [self setLeftBarButton:button];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)isRootViewController {
    return (self.navigationController.viewControllers.firstObject == self);
}

+ (UIWindow *)window {
    return [UIApplication sharedApplication].windows[0];
}


#pragma mark rotation
//ios6
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

//ios4 and ios5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end


