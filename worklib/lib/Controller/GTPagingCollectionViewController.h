//
//  GTPagingCollectionViewController.h
//  iGuitar
//
//  Created by carusd on 15/7/16.
//  Copyright (c) 2015年 GuitarGG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTNextPageIndicatorView.h"

@interface GTPagingCollectionViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>


@property (nonatomic) NSInteger pageNo;
@property (nonatomic) NSInteger total;
@property (nonatomic) NSInteger pageSize;
@property (nonatomic) BOOL isLoading;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSDictionary *datas;
@property (nonatomic, strong) UICollectionView *collectionView;


@property (nonatomic, strong) NSArray *constraints4TableView;



- (BOOL)hasNextPage;
- (void)loadDataWithPage:(NSInteger)index;
- (void)handleLoadedData:(NSDictionary *)data;
- (void)handleLoadedError:(NSError *)e;
- (void)refresh;

- (UIView *)customTableFooterView;
- (GTNextPageIndicatorView *)nextPageIndicatorView;
@end
