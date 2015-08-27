//
//  GTPullToRefreshView.m
//  worklib
//
//  Created by carusd on 15/8/26.
//  Copyright (c) 2015年 carusd. All rights reserved.
//

#import "GTPullToRefreshView.h"

@interface GTPullToRefreshView ()

@property (nonatomic, strong) UIImageView *stringImgView;
@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation GTPullToRefreshView

- (id)init {
    self = [super init];
    
    if (self) {

        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)realTimeContentOffset:(CGPoint)offset {
    
    if (GTPullToRefreshStateLoading == self.pullState) {
        return;
    }
    
    if (offset.y >= 0) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
    }
    
}

- (void)startToLoad {
    if (GTPullToRefreshStateNormal == self.pullState) {
        return;
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    self.pullState = GTPullToRefreshStateLoading;
    [self playLoadingAnimation];
}

- (void)stopLoading {
    self.pullState = GTPullToRefreshStateNormal;
    [self stopLoadingAnimation];
}

- (void)playLoadingAnimation {
    
}

- (void)stopLoadingAnimation {
    
}

- (BOOL)isAnimating {
    return (self.pullState == GTPullToRefreshStateLoading);
}


@end
