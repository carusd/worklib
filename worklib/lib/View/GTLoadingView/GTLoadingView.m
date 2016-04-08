//
//  GTLoadingView.m
//  iGuitar
//
//  Created by carusd on 14-8-9.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "GTLoadingView.h"
#import "GTViewController.h"

@interface GTLoadingView ()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation GTLoadingView

GTLoadingView *_loadingView;

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 100, 100);
        self.layer.cornerRadius = 10;
        self.center = GTCenterAtWindow;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:self.indicatorView];
        self.indicatorView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height  / 2);
        
        
    }
    return self;
}

+ (instancetype)instance {
    static dispatch_once_t p;
    dispatch_once(&p, ^(){
        _loadingView = [[GTLoadingView alloc] init];
    });
    
    return _loadingView;
}


+ (void)show {
    if (![GTLoadingView instance].superview) {
        [[GTViewController window] addSubview:[GTLoadingView instance]];
        [[GTLoadingView instance].indicatorView startAnimating];
    }
}

+ (void)hide {
    [[GTLoadingView instance].indicatorView stopAnimating];
    [[GTLoadingView instance] removeFromSuperview];
}
@end
