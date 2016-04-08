//
//  GTPullToRefreshView.h
//  worklib
//
//  Created by carusd on 15/8/26.
//  Copyright (c) 2015年 carusd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GTPullToRefreshStateNormal,
    GTPullToRefreshStateLoading,
    GTPullToRefreshStateReadyToLoad
} GTPullToRefreshState;

#define PullValve (50.0)

@interface GTPullToRefreshView : UIControl

@property (nonatomic, setter=setPullState:) GTPullToRefreshState pullState;

- (void)realTimeContentOffset:(CGPoint)offset;

- (void)startToLoad;
- (void)stopLoading;

@end
