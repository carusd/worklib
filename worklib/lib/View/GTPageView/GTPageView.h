//
//  GTPageView.h
//  PCMClient3
//
//  Created by ray carusd on 13-6-5.
//  Copyright (c) 2013年 太平洋网络. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTPageViewDelegate, GTPageViewDataSource;

@interface GTPageView : UIView<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) IBOutlet id<GTPageViewDelegate> delegate;
@property (nonatomic, assign) IBOutlet id<GTPageViewDataSource> dataSource;
@property (nonatomic, readonly) NSInteger numberOfItems;
@property (nonatomic, readonly) NSInteger numberOfVisibleItems;
@property (nonatomic, readonly) NSInteger currentItemIndex;
@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, readonly) NSSet *visibleIndices;
- (void)reloadData;
- (UIView *)currentItemView;
- (UIView *)itemViewAtIndex:(NSInteger)index;
- (void)scrollToPageIndex:(NSInteger)index;
- (void)scrollToNextPage;
- (void)scrollToPreviousPage;
- (void)scrollToPageIndex:(NSInteger)index animated:(BOOL)animated;
@end


@protocol GTPageViewDataSource <NSObject>
@required
- (NSUInteger)numberOfItemsInGTPageView:(GTPageView *)pageView;
- (UIView *)pageView:(GTPageView *)pageView viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view;
@optional
- (NSUInteger)numberOfVisibleItemsInGTPageView:(GTPageView *)pageView;
- (NSInteger)startIndexInGTPageView:(GTPageView *)pageView;
- (void)pageView:(GTPageView *)pageView didLoadItemAtIndex:(NSUInteger)index;
- (void)pageView:(GTPageView *)pageView willLoadItemAtIndex:(NSUInteger)index;
@end

@protocol GTPageViewDelegate <NSObject>
@optional
- (void)pageView:(GTPageView *)pageView didSelectItemAtIndex:(NSInteger)index;
- (void)pageView:(GTPageView *)pageView didScrollToPageIndex:(NSInteger)index;
- (void)pageViewDidScroll:(GTPageView *)pageView;
@end