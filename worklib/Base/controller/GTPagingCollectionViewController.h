//
//  GTPagingCollectionViewController.h
//  iGuitar
//
//  Created by carusd on 15/7/16.
//  Copyright (c) 2015年 GuitarGG. All rights reserved.
//

#import "GTViewController.h"
#import "GTNextPageIndicatorView.h"

@interface GTPagingCollectionViewController : GTViewController<UICollectionViewDataSource, UICollectionViewDelegate>


@property (nonatomic) NSInteger pageNo;
@property (nonatomic) NSInteger total;
@property (nonatomic) NSInteger pageSize;
@property (nonatomic) BOOL isLoading;
@property (nonatomic, readonly) NSMutableArray *dataArray;
@property (nonatomic, strong) NSDictionary *datas;
@property (nonatomic, strong) UICollectionView *collectionView;


@property (nonatomic, strong) NSArray *constraints4TableView;



- (BOOL)hasNextPage;
- (void)loadDataWithPage:(NSInteger)index;
- (void)handleLoadedData:(NSDictionary *)data;

- (UIView *)customTableFooterView;
- (GTNextPageIndicatorView *)nextPageIndicatorView;
@end
