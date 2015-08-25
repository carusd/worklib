//
//  GTColumnView.h
//  PCMClient4
//
//  Created by carusd on 14-4-18.
//  Copyright (c) 2014年 太平洋网络. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTColumnView;

@protocol GTColumnViewDataSource<NSObject>


@required
- (NSUInteger)numberOfColumns;
- (NSString *)stringForColumnView:(GTColumnView *)columnView atIndex:(NSUInteger)index;
@end

@protocol GTColumnViewDelegate<NSObject>

@optional
- (void)columnView:(GTColumnView *)columnView willSelectAtIndex:(NSUInteger)index;
- (void)columnView:(GTColumnView *)columnView didSelectAtIndex:(NSUInteger)index;

@end


@interface GTColumnView : UIView<UIScrollViewDelegate>

@property (nonatomic, weak) id<GTColumnViewDataSource> dataSource;
@property (nonatomic, weak) id<GTColumnViewDelegate> delegate;
@property (nonatomic, readonly) NSInteger currentIndex;

@property (nonatomic, readonly) UIImageView *backgroundImgView;
@property (nonatomic, strong) UIView *selectedView;

@property (nonatomic) CGFloat space;  // 栏目间隔
@property (nonatomic) CGFloat margin; // 边界

@property (nonatomic) CGFloat columnWidth; // 每行的宽度，默认是50
@property (nonatomic) CGFloat preferredColumnWidth;

@property (nonatomic) CGFloat minColumnWidth;
@property (nonatomic) CGFloat preferredMinColumnWidth;

@property (nonatomic, strong) UIFont *textFont;

@property (nonatomic, strong) UIColor *normalStateTextColor;
@property (nonatomic, strong) UIColor *selectedStateTextColor;

@property (nonatomic, strong) UIImage *normalStateBackgroundImage;
@property (nonatomic, strong) UIImage *selectedStateBackgroundImage;

@property (nonatomic, strong) UIColor *normarStateBackgroundColor;
@property (nonatomic, strong) UIColor *selectedStateBackgroundColor;

- (void)changeCurrentSelected:(NSInteger)index;
- (void)reloadData;

@end
