//
//  GTPagingTableViewController.h
//  iGuitar
//
//  Created by carusd on 14-7-2.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "GTViewController.h"
#import "GTNextPageIndicatorView.h"
#import "GTPullToRefreshView.h"



@interface GTPagingTableViewController : GTViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) NSInteger pageNo;
@property (nonatomic) NSInteger total;
@property (nonatomic) NSInteger pageSize;
@property (nonatomic) BOOL isLoading;
@property (nonatomic, readonly) NSMutableArray *dataArray;
@property (nonatomic, strong) NSDictionary *datas;
@property (nonatomic) GTPagingDataSourceType pagingDataSourceType;

@property (nonatomic, strong) NSArray *constraints4TableView;

@property (nonatomic, readonly) NSLayoutConstraint *top4Refresh;

- (BOOL)hasNextPage;
- (void)loadDataWithPage:(NSInteger)index;
- (void)handleLoadedData:(NSDictionary *)data;

- (UIView *)customTableFooterView;
- (GTNextPageIndicatorView *)nextPageIndicatorView;
@end
