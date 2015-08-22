//
//  GTScrollViewController.m
//  iGuitar
//
//  Created by carusd on 15/2/16.
//  Copyright (c) 2015年 GuitarGG. All rights reserved.
//

#import "GTScrollViewController.h"

@interface GTScrollViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation GTScrollViewController
@synthesize scrollView = _scrollView;

- (void)dealloc {
    self.scrollView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (GTIOSVersion >= 7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:self.scrollView];
}



- (void)currentMenuIndexDidChange {
    
}

- (void)scrollToIndex:(NSInteger)index {
    [self.scrollView setContentOffset:CGPointMake(GTView_W(self.scrollView) * index, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentMenuIndex = scrollView.contentOffset.x / GTView_W(self.scrollView);
    
    [self currentMenuIndexDidChange];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.currentMenuIndex = scrollView.contentOffset.x / GTView_W(self.scrollView);
    
    [self currentMenuIndexDidChange];
}

@end
