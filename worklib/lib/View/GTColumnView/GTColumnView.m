//
//  GTColumnView.m
//  PCMClient4
//
//  Created by carusd on 14-4-18.
//  Copyright (c) 2014年 太平洋网络. All rights reserved.
//

#import "GTColumnView.h"

@interface GTColumnView ()

@property (nonatomic) NSInteger numberOfColumns;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *backgroundImgView;
@end

@implementation GTColumnView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.backgroundImgView.userInteractionEnabled = YES;
        [self addSubview:self.backgroundImgView];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.scrollsToTop = NO;
        self.scrollView.delegate = self;
        self.scrollView.clipsToBounds = YES;
        [self addSubview:self.scrollView];
        
        
        self.normalStateTextColor = [UIColor whiteColor];
        self.selectedStateTextColor = [UIColor whiteColor];
        self.textFont = [UIFont systemFontOfSize:14];
        
        self.normarStateBackgroundColor = [UIColor clearColor];
        self.selectedStateBackgroundColor = [UIColor clearColor];
        
        
        self.selectedView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 100, self.frame.size.height)];
        
        
        
        self.space = 5;
        self.margin = 10;
        self.columnWidth = 50;
    }
    return self;
}



- (void)setDataSource:(id<GTColumnViewDataSource>)dataSource {
    if (dataSource) {
        _dataSource = dataSource;
        [self reloadData];
    }
}

- (void)setMinColumnWidth:(CGFloat)minColumnWidth {
    _minColumnWidth = minColumnWidth;
    if (self.columnWidth <= _minColumnWidth) {
        self.columnWidth = _minColumnWidth;
    }
}

- (void)setColumnWidth:(CGFloat)columnWidth {
    if (columnWidth <= self.minColumnWidth) {
        _columnWidth = self.minColumnWidth;
    } else {
        _columnWidth = columnWidth;
    }
}

- (BOOL)canFillContainer {
    if ([self.dataSource respondsToSelector:@selector(numberOfColumns)]) {
        self.numberOfColumns = [self.dataSource numberOfColumns];
    }
    CGFloat contentSizeWidth = self.numberOfColumns * self.preferredColumnWidth + (self.numberOfColumns - 1) * self.space + self.margin * 2;
    return contentSizeWidth >= CGRectGetWidth(self.bounds);
}

- (void)beforeReloadData {
    if (![self canFillContainer]) {
        CGFloat totalSpacing = (self.numberOfColumns - 1) * self.space;
        if (0 == self.numberOfColumns) {
            _minColumnWidth = 50;
            _columnWidth = 50;
        } else {
            _minColumnWidth = (CGRectGetWidth(self.bounds) - self.margin * 2 - totalSpacing) / self.numberOfColumns;
            _columnWidth = _minColumnWidth;
        }
        
    } else {
        self.minColumnWidth = self.preferredMinColumnWidth;
        self.columnWidth = self.preferredColumnWidth;
    }
}

- (void)afterReloadData {
    
}

- (void)reloadData {
    [self beforeReloadData];
    [self _reloadData];
    [self afterReloadData];
    
}

- (void)_reloadData {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.scrollView addSubview:self.selectedView];
    
    CGFloat contentSizeWidth = self.margin;
    //    CGFloat buttonWidthInThisWidth = self.frame.size.width - contentSizeWidth;
    //    CGFloat buttonWidth = buttonWidthInThisWidth / self.maxNumberOfColumnsInThisWidth;
    
    self.selectedView.frame = CGRectMake(0, CGRectGetMinY(self.selectedView.frame), self.columnWidth, CGRectGetHeight(self.selectedView.bounds));
    
    if ([self.dataSource respondsToSelector:@selector(numberOfColumns)]) {
        self.numberOfColumns = [self.dataSource numberOfColumns];
    }
    
    for (NSInteger i=0; i<self.numberOfColumns; i++) {
        UIButton *columnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSString *stringAtIndex = nil;
        if ([self.dataSource respondsToSelector:@selector(stringForColumnView:atIndex:)]) {
            stringAtIndex = [self.dataSource stringForColumnView:self atIndex:i];
        }
        
        [columnButton setTitle:stringAtIndex forState:UIControlStateNormal];
        columnButton.tag = i+1;
        [columnButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        if (self.textFont) {
            columnButton.titleLabel.font = self.textFont;
        }
        
        if (self.normalStateTextColor) {
            [columnButton setTitleColor:self.normalStateTextColor forState:UIControlStateNormal];
        }
        
        if (self.selectedStateTextColor) {
            [columnButton setTitleColor:self.selectedStateTextColor forState:UIControlStateSelected];
        }
        
        if (self.normalStateBackgroundImage) {
            [columnButton setBackgroundImage:self.normalStateBackgroundImage forState:UIControlStateNormal];
        }
        
        if (self.selectedStateBackgroundImage) {
            [columnButton setBackgroundImage:self.selectedStateBackgroundImage forState:UIControlStateSelected];
        }
        
        if (self.normarStateBackgroundColor) {
            columnButton.backgroundColor = self.normarStateBackgroundColor;
        }
        
        
        columnButton.frame = CGRectMake(self.margin + (self.columnWidth + self.space) * i, 0, self.columnWidth, self.frame.size.height);
        
        contentSizeWidth += (self.columnWidth + self.space);
        [self.scrollView addSubview:columnButton];
        
        if (i == self.currentIndex) {
            self.selectedView.frame = CGRectMake(columnButton.frame.origin.x, CGRectGetMinY(self.selectedView.frame), self.columnWidth, CGRectGetHeight(self.selectedView.bounds));
            columnButton.selected = YES;
            if (self.selectedStateBackgroundColor) {
                columnButton.backgroundColor = self.selectedStateBackgroundColor;
            }
            
        }
    }
    contentSizeWidth -= self.space;
    contentSizeWidth += self.margin;
    self.scrollView.contentSize = CGSizeMake(contentSizeWidth, self.frame.size.height);
    NSLog(@"scrollview content size %@", NSStringFromCGSize(self.scrollView.contentSize));
}

- (void)didTapButton:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(columnView:willSelectAtIndex:)]) {
        [self.delegate columnView:self willSelectAtIndex:button.tag-1];
    }
    
    [self changeCurrentSelected:button.tag-1];
    
    if ([self.delegate respondsToSelector:@selector(columnView:didSelectAtIndex:)]) {
        [self.delegate columnView:self didSelectAtIndex:button.tag-1];
    }
}

- (void)changeCurrentSelected:(NSInteger)index {
    UIButton *button = (UIButton *)[self.scrollView viewWithTag:index+1];
    
    UIButton *oldSelectedButton = (UIButton *)[self.scrollView viewWithTag:_currentIndex+1];
    oldSelectedButton.selected = NO;
    if (self.normarStateBackgroundColor) {
        oldSelectedButton.backgroundColor = self.normarStateBackgroundColor;
    }
    _currentIndex = button.tag-1;
    
    button.selected = YES;
    if (self.selectedStateBackgroundColor) {
        button.backgroundColor = self.selectedStateBackgroundColor;
    }
    
    [UIView animateWithDuration:0.2 animations:^(){
        self.selectedView.frame = CGRectMake(button.frame.origin.x, CGRectGetMinY(self.selectedView.frame), button.frame.size.width, CGRectGetHeight(self.selectedView.bounds));
    }];
}

- (void)selectIndex:(NSUInteger)index {
    UIButton *columnButton = (UIButton *)[self.scrollView viewWithTag:index];
    if (columnButton) {
        [self didTapButton:columnButton];
    }
}

@end
