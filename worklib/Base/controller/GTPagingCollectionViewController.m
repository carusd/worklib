//
//  GTPagingCollectionViewController.m
//  iGuitar
//
//  Created by carusd on 15/7/16.
//  Copyright (c) 2015年 GuitarGG. All rights reserved.
//

#import "GTPagingCollectionViewController.h"
#import "PullStringToRefresh.h"


@interface GTPagingCollectionViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) GTNextPageIndicatorView *nextPageIndicatorView;

@property (nonatomic, strong) PullStringToRefresh *refresh;
@property (nonatomic, strong) NSLayoutConstraint *top4Refresh;

@end

@implementation GTPagingCollectionViewController

- (void)dealloc {
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.refresh = [[PullStringToRefresh alloc] init];
    self.refresh.translatesAutoresizingMaskIntoConstraints = NO;
    [self.refresh addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    self.refresh.hidden = YES;
    
    [self.view addSubview:self.refresh];
    NSDictionary *refreshViews = NSDictionaryOfVariableBindings(_refresh);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_refresh]|" options:0 metrics:nil views:refreshViews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_refresh(50)]" options:0 metrics:nil views:refreshViews]];
    self.top4Refresh = [NSLayoutConstraint constraintWithItem:self.refresh attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.view addConstraint:self.top4Refresh];
}

#pragma mark load data
- (void)handleLoadedData:(NSDictionary *)dic dataSourceType:(GTPagingDataSourceType)dataSourceType {
    NSMutableDictionary *mutableDatas = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSArray *data = mutableDatas[@"data"];
    [mutableDatas removeObjectForKey:@"data"];
    self.datas = [NSDictionary dictionaryWithDictionary:mutableDatas];
    
    if (!self.dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    [self.dataArray addObjectsFromArray:data];
    
    self.pageNo = [self.datas[@"pageNo"] integerValue];
    self.total = [self.datas[@"total"] integerValue];
    self.pageSize = [self.datas[@"pageSize"] integerValue];
    
    [self.collectionView reloadData];
    
    if (self.hasNextPage) {
        GTNextPageIndicatorView *indicator = self.nextPageIndicatorView;
        [indicator.indicatorView stopAnimating];
//        self.collectionView.tableFooterView = indicator;
    } else {
//        self.collectionView.tableFooterView = self.customTableFooterView;
    }
    
    self.isLoading = NO;
    [self hide];
}

- (void)loadDataWithPage:(NSInteger)index {
    self.isLoading = YES;
}

- (void)reloadData {
    
    self.datas = nil;
    self.dataArray = nil;
    self.isLoading = YES;
    [self loadDataWithPage:1];
}

- (void)handleLoadedData:(NSDictionary *)dic {
    [self handleLoadedData:dic dataSourceType:GTPagingDataSourceTypeNetwork];
}

- (BOOL)hasNextPage {
    if (self.pageSize <= 0) {
        return NO;
    }
    @try {
        NSInteger mode = self.total % self.pageSize;
        NSInteger pageCount = 0;
        if (mode > 0) {
            pageCount = self.total / self.pageSize + 1;
        } else {
            pageCount = self.total / self.pageSize;
        }
        
        return self.pageNo < pageCount;
    }
    @catch (NSException *exception) {
        return NO;
    }
}


#pragma mark refresh
- (void)reload {
    [self reloadData];
}

- (void)hide {
    [UIView animateWithDuration:.2 animations:^{
        
        [self.refresh stopLoading];
        self.collectionView.contentInset = UIEdgeInsetsZero;
    }];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


#pragma mark flow layout delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(GTDeviceWidth, 10);
}

#pragma mark scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.refresh realTimeContentOffset:scrollView.contentOffset];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"pull state %ld", self.refresh.pullState);
    if (PullStringToRefreshStateReadyToLoad == self.refresh.pullState) {
        [self.refresh startToLoad];
        
        scrollView.contentInset = UIEdgeInsetsMake(PullValve, 0, 0, 0);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y + scrollView.frame.size.height  >= scrollView.contentSize.height && self.isLoading == NO && self.hasNextPage) {
        //        GTNextPageIndicatorView *loadNextPageLabel = (GTNextPageIndicatorView *)self.tableView.tableFooterView;
        self.nextPageIndicatorView.text = @"正在加载";
        
        [self.nextPageIndicatorView.indicatorView startAnimating];
        [self loadDataWithPage:self.pageNo+1];
    }
}
@end
