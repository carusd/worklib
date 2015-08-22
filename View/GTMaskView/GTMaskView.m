//
//  GTMaskView.m
//  iGuitar
//
//  Created by carusd on 14-8-18.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "GTMaskView.h"
#import "GTViewController.h"

@implementation GTMaskView



- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, GTDeviceWidth, GTDeviceHeight);
//        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
        [self addGestureRecognizer:tap];
        tap.delegate = self;
        
    }
    
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == gestureRecognizer.view) {
        return YES;
    } else {
        return NO;
    }
}

- (void)handleTap {
    [self dismiss];
    
}

- (void)show {
    if ([self.delegate respondsToSelector:@selector(maskViewWillShow:)]) {
        [self.delegate maskViewWillShow:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(subviewToMaskView:)]) {
        UIView *subview = [self.delegate subviewToMaskView:self];
        [self addSubview:subview];
        
        [[GTViewController window] addSubview:self];
        
    }
    [UIView animateWithDuration:0.35 animations:^{
//        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(maskViewDidShow:)]) {
            [self.delegate maskViewDidShow:self];
        }
    }];
    
}

- (void)dismiss {
    if ([self.delegate respondsToSelector:@selector(maskViewWillDismiss:)]) {
        [self.delegate maskViewWillDismiss:self];
    }
    [UIView animateWithDuration:0.35 animations:^{
//        self.frame = CGRectMake(0, GTDeviceHeight, GTDeviceWidth, GTDeviceHeight);
//        self.alpha = 0;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
        
        if ([self.delegate respondsToSelector:@selector(maskViewDidDismiss:)]) {
            [self.delegate maskViewDidDismiss:self];
        }
    }];
}


@end
