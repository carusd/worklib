//
//  GTLoadingView.h
//  iGuitar
//
//  Created by carusd on 14-8-9.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTLoadingView : UIView

@property (nonatomic, readonly) UIActivityIndicatorView *indicatorView;

+ (void)show;
+ (void)hide;

@end
