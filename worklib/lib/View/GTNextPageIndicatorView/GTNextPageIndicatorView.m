//
//  GTNextPageIndicatorView.m
//  iGuitar
//
//  Created by carusd on 14-7-2.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "GTNextPageIndicatorView.h"
#import "GTMacros.h"
#import "GTConstants.h"

@interface GTNextPageIndicatorView ()
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation GTNextPageIndicatorView

- (id)init {
    self = [super init];
    if (self) {
        self.normalText = @"查看更多";
        self.loadingText = @"正在加载";
        
        [self setup];
    }
    
    return self;
}

- (id)initWithNormalText:(NSString *)normalText loadingText:(NSString *)loadingText {
    self = [super init];
    if (self) {
        self.normalText = normalText;
        self.loadingText = loadingText;
        
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.frame = CGRectMake(0, 0, GTDeviceWidth, 44);
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.textLabel.backgroundColor = [UIColor clearColor];
//    self.textLabel.textColor = GTColor(51, 51, 51, 1);
    self.textLabel.textColor = [UIColor darkGrayColor];
    self.textLabel.text = self.normalText;
    self.textLabel.font = [UIFont boldSystemFontOfSize:14];
    
    [self addSubview:self.textLabel];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.indicatorView];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:-5]];
}

- (void)setStatus:(GTNextPageIndicatorViewStatus)status {
    if (GTNextPageIndicatorViewStatusLoading == status) {
        self.textLabel.text = self.loadingText;
    } else {
        self.textLabel.text = self.normalText;
    }
}
@end
