//
//  GTMaskView.h
//  iGuitar
//
//  Created by carusd on 14-8-18.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTMaskView;

@protocol GTMaskViewDelegate <NSObject>

@optional
- (UIView *)subviewToMaskView:(GTMaskView *)maskView;
- (void)didTapMaskView:(GTMaskView *)maskView;


- (void)maskViewWillDismiss:(GTMaskView *)maskView;
- (void)maskViewDidDismiss:(GTMaskView *)maskView;

- (void)maskViewWillShow:(GTMaskView *)maskView;
- (void)maskViewDidShow:(GTMaskView *)maskView;


@end

@interface GTMaskView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<GTMaskViewDelegate> delegate;


- (void)show;
- (void)dismiss;


@end
