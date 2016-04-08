//
//  GTScrollViewController.h
//  iGuitar
//
//  Created by carusd on 15/2/16.
//  Copyright (c) 2015年 GuitarGG. All rights reserved.
//

#import "GTViewController.h"

@interface GTScrollViewController : GTViewController {
    UIScrollView *_scrollView;
}

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic) NSInteger menuCount;
@property (nonatomic) NSInteger currentMenuIndex;

- (void)scrollToIndex:(NSInteger)index;

- (void)currentMenuIndexDidChange;
@end
