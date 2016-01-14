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

@interface GTNextPageIndicatorView ()
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation GTNextPageIndicatorView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.text = @"查看更多";
        self.textLabel.textColor = [UIColor gtBlackColor];
        [self addSubview:self.textLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.indicatorView];
        
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:5]];
    }
    return self;
}

- (void)setText:(NSString *)text {
    self.textLabel.text = text;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
