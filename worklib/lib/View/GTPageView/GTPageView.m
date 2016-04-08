//
//  GTPageView.m
//  PCMClient3
//
//  Created by ray carusd on 13-6-5.
//  Copyright (c) 2013年 太平洋网络. All rights reserved.
//

#import "GTPageView.h"

@interface GTPageView ()


@property (nonatomic, strong) NSDictionary *itemViews;
@property (nonatomic, strong) NSMutableSet *itemViewPool;
@property (nonatomic, assign) NSInteger numberOfVisibleItems;
@property (nonatomic, assign) NSInteger numberOfItems;
@property (nonatomic, assign) NSInteger currentItemIndex;
@end

@implementation GTPageView

- (void)dealloc {
    self.scrollView.delegate = nil;
    self.scrollView = nil;
    self.itemViewPool = nil;
    self.itemViews = nil;
    self.delegate = nil;
    self.dataSource = nil;
    
}

- (void)setDataSource:(id<GTPageViewDataSource>)dataSource_
{
    if (self.dataSource != dataSource_)
    {
        _dataSource = dataSource_;
        if (self.dataSource)
        {
            [self reloadData];
        }
    }
}

- (void)setDelegate:(id<GTPageViewDelegate>)delegate_
{
    if (_delegate != delegate_)
    {
        _delegate = delegate_;
        if (_delegate && _dataSource)
        {
            [self layOutItemViews];
        }
    }
}

- (void)setBounces:(BOOL)bounces {
    self.scrollView.bounces = bounces;
}

- (NSInteger)currentItemIndex
{
    return [self clampedIndex:roundf(self.scrollView.contentOffset.x / self.scrollView.frame.size.width)];
}

- (NSInteger)indexOfItemView:(UIView *)view
{
    NSInteger index = [[self.itemViews allValues] indexOfObject:view];
    if (index != NSNotFound)
    {
        return [[[self.itemViews allKeys] objectAtIndex:index] integerValue];
    }
    return NSNotFound;
}

- (void)setItemView:(UIView *)view forIndex:(NSInteger)index {
    [(NSMutableDictionary *)self.itemViews setObject:view forKey:[NSNumber numberWithInteger:index]];
}

- (NSSet *)visibleIndices {
    NSMutableSet *visibleIndices = [NSMutableSet setWithCapacity:self.numberOfVisibleItems];
    
    NSInteger offset = self.currentItemIndex - self.numberOfVisibleItems / 2;
    offset = MAX(offset, 0);
    for (NSInteger i=0; i<self.numberOfVisibleItems; i++) {
        NSInteger index = [self clampedIndex:i+offset];
        [visibleIndices addObject:[NSNumber numberWithInteger:index]];
    }
    return visibleIndices;
}

- (UIView *)containView:(UIView *)view
{
    UIView *container = [[UIView alloc] initWithFrame:view.frame];
//    if ([view isMemberOfClass:[UIView class]]) {
//        container.backgroundColor = [UIColor redColor];
//    }
    
//    container.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    //add tap gesture recogniser
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    tapGesture.delegate = (id <UIGestureRecognizerDelegate>)self;
    [container addGestureRecognizer:tapGesture];
    
    
    [container addSubview:view];
    return container;
}

- (UIView *)itemViewAtIndex:(NSInteger)index
{
    return [self.itemViews objectForKey:[NSNumber numberWithInteger:index]];
}

- (UIView *)currentItemView
{
    return [self itemViewAtIndex:self.currentItemIndex];
}

- (id)init {
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    //应该是自适应之后做setup的，因为你的frame不对 BY BJ
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self) {
        [self reloadData];
    }
}


- (void)setUp {
    UIScrollView *scrollView_ = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView = scrollView_;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    [self addSubview:self.scrollView];
    
}

- (void)layOutItemViews {
    if (!self.dataSource) {
        return;
    }
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(self.numberOfItems * self.frame.size.width, self.frame.size.height);
    if ([self.dataSource respondsToSelector:@selector(startIndexInGTPageView:)]) {
        NSInteger startIndex = [self.dataSource startIndexInGTPageView:self];
        if (startIndex < self.numberOfItems) {
            self.scrollView.contentOffset = CGPointMake(startIndex * self.scrollView.frame.size.width, 0);
        }
        
    }
    
    [self loadUnloadViews];
}

- (NSInteger)clampedIndex:(NSInteger)index {
    return MIN(MAX(index, 0), self.numberOfItems - 1);
}

- (void)loadUnloadViews {
    NSMutableSet *visibleIndices = [NSMutableSet setWithCapacity:self.numberOfVisibleItems];
    
    NSInteger offset = self.currentItemIndex - self.numberOfVisibleItems / 2;
    offset = MAX(offset, 0);
    for (NSInteger i=0; i<self.numberOfVisibleItems; i++) {
        NSInteger index = [self clampedIndex:i+offset];
        [visibleIndices addObject:[NSNumber numberWithInteger:index]];
    }
    
    //remove unvisible views
    for (NSNumber *number in [self.itemViews allKeys]) {
        if (![visibleIndices containsObject:number]) {
            UIView *view = [self.itemViews objectForKey:number];
            
            [self queueItemView:view];
            [view.superview removeFromSuperview];
            [(NSMutableDictionary *)self.itemViews removeObjectForKey:number];
        }
    }
    
    // add visible views
    for (NSNumber *number in visibleIndices) {
        UIView *view = [self.itemViews objectForKey:number];
        if (!view) {
            [self  loadViewAtIndex:[number integerValue]];
        }
    }
}

- (UIView *)loadViewAtIndex:(NSInteger)index withContainerView:(UIView *)containerView {
    UIView *view = [self.dataSource pageView:self viewForItemAtIndex:index reusingView:[self dequeueItemView]];
    
    if (!view) {
        view = [[UIView alloc] init];
    }
    [self setItemView:view forIndex:index];
    
    if ([self.dataSource respondsToSelector:@selector(pageView:willLoadItemAtIndex:)]) {
        [self.dataSource pageView:self willLoadItemAtIndex:index];
    }
    
    //layout the view
    view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    
    if (containerView)
    {
        UIView *oldItemView = [containerView.subviews lastObject];
        if (index >= 0 && index < self.numberOfItems) {
            [self queueItemView:view];
        }
        [oldItemView removeFromSuperview];
        containerView.frame = view.frame;
        [containerView addSubview:view];
    }
    else
    {
        [self.scrollView addSubview:[self containView:view]];
    }
    
    view.superview.center = CGPointMake(index * self.bounds.size.width + self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    
    if ([self.dataSource respondsToSelector:@selector(pageView:didLoadItemAtIndex:)]) {
        [self.dataSource pageView:self didLoadItemAtIndex:index];
    }
    return view;
}

- (UIView *)loadViewAtIndex:(NSInteger)index {
    return [self loadViewAtIndex:index withContainerView:nil];
}

- (void)reloadData {
    for (UIView *view in [self.itemViews allValues]) {
        [view.superview removeFromSuperview];
    }
    
    if (!self.dataSource) {
        return;
    }
    
    self.numberOfItems = [self.dataSource numberOfItemsInGTPageView:self];
    
    self.numberOfVisibleItems = self.numberOfItems;
    if ([self.dataSource respondsToSelector:@selector(numberOfVisibleItemsInGTPageView:)]) {
        self.numberOfVisibleItems = [self.dataSource numberOfVisibleItemsInGTPageView:self];
        _numberOfVisibleItems = MIN(_numberOfItems, _numberOfVisibleItems);
    }
    
    self.itemViews = [NSMutableDictionary dictionaryWithCapacity:self.numberOfVisibleItems];
    self.itemViewPool = [NSMutableSet setWithCapacity:self.numberOfVisibleItems];
    
    [self layOutItemViews];
//    self.scrollView.frame = self.bounds;
//    self.scrollView.contentSize = CGSizeMake(self.numberOfItems * self.frame.size.width, self.frame.size.height);
    
}

- (void)scrollToPageIndex:(NSInteger)index animated:(BOOL)animated {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * index, 0) animated:animated];
    if (!animated) {
        [self loadUnloadViews];
        if ([_delegate respondsToSelector:@selector(pageView:didScrollToPageIndex:)]) {
            [_delegate pageView:self didScrollToPageIndex:self.currentItemIndex];
        }
    }
}

- (void)scrollToPageIndex:(NSInteger)index {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * index, 0) animated:YES];
}

- (void)scrollToNextPage {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * [self clampedIndex:self.currentItemIndex + 1], 0) animated:YES];
}

- (void)scrollToPreviousPage {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * [self clampedIndex:self.currentItemIndex - 1], 0) animated:YES];
}

- (void)queueItemView:(UIView *)view {
    if (view) {
        [self.itemViewPool addObject:view];
    }
}

- (UIView *)dequeueItemView {
    UIView *view = [self.itemViewPool anyObject];
    if (view) {
        [self.itemViewPool removeObject:view];
    }
    return view;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (![self.delegate respondsToSelector:@selector(pageView:didSelectItemAtIndex:)]) {
        return NO;
    }
    
    return YES;
}

- (void)didTap:(UITapGestureRecognizer *)tapGesture
{
    NSInteger index = [self indexOfItemView:[tapGesture.view.subviews lastObject]];

    if ([self.delegate respondsToSelector:@selector(pageView:didSelectItemAtIndex:)])
    {
        [self.delegate pageView:self didSelectItemAtIndex:index];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadUnloadViews];
    
    if ([_delegate respondsToSelector:@selector(pageView:didScrollToPageIndex:)]) {
        [_delegate pageView:self didScrollToPageIndex:self.currentItemIndex];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self loadUnloadViews];
    
    if ([_delegate respondsToSelector:@selector(pageView:didScrollToPageIndex:)]) {
        [_delegate pageView:self didScrollToPageIndex:self.currentItemIndex];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([_delegate respondsToSelector:@selector(pageViewDidScroll:)]) {
        [_delegate pageViewDidScroll:self];
    }
}



@end
