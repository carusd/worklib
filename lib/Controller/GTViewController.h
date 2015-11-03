//
//  GTViewController.h
//  iGuitar
//
//  Created by carusd on 14-5-2.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Text.h"
#import "GTConstants.h"
#import "GTMacros.h"

#import "UIImage+load.h"
#import "NSString+timestamp.h"
#import "GTMaskView.h"
#import "NSFileManager+AppRef.h"
#import "GTLoadingView.h"

typedef enum : NSUInteger {
    GTPagingDataSourceTypeNetwork,
    GTPagingDataSourceTypeSqlite
} GTPagingDataSourceType;


@interface GTViewController : UIViewController {
    GTMaskView *_maskView;
    UINavigationBar *_navBar;
    
    @protected
    NSInteger _modelId;
    NSDictionary *_ext;
}

@property (nonatomic, getter = isRootViewController) BOOL isRootViewController;

@property (nonatomic, strong, setter = setLeftBarButton:) UIButton *leftBarButton;
@property (nonatomic, strong, setter = setRightBarButton:) UIButton *rightBarButton;
@property (nonatomic, strong, setter = setBarTitle:) NSString *barTitle;
@property (nonatomic, strong, setter = setBarTitleView:) UIView *barTitleView;
@property (nonatomic, readonly) UIView *navBar;


@property (nonatomic, strong) UISwipeGestureRecognizer *openConsoleGestureReg;
@property (nonatomic, strong) UISwipeGestureRecognizer *openDebugGestureReg;

@property (nonatomic, strong) GTMaskView *maskView;

- (id)initWithModelId:(NSInteger)modelId ext:(NSDictionary *)ext;

+ (UIWindow *)window;

- (void)showLoading;
- (void)hideLoading;

- (void)setupNavBar;

- (void)setDetaultBackButton;
- (void)setWhiteBackButton;
- (void)setBlackBackButton;

@end
