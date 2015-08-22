//
//  GTNextPageIndicatorView.m
//  iGuitar
//
//  Created by carusd on 14-7-2.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "GTNextPageIndicatorView.h"
#import "UIColor+Text.h"
#import "GTConstants.h"

@implementation GTNextPageIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, GTDeviceWidth, 44);
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor gtBlackColor];
        self.text = @"查看更多";
        
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicatorView.center = CGPointMake(100, 22);
        [self addSubview:self.indicatorView];
    }
    return self;
}

@end
