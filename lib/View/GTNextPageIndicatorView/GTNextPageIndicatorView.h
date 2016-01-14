//
//  GTNextPageIndicatorView.h
//  iGuitar
//
//  Created by carusd on 14-7-2.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTNextPageIndicatorView : UIView

- (void)setText:(NSString *)text;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end
