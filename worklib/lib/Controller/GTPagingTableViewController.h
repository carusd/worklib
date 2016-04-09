//
//  GTPagingTableViewController.h
//  iGuitar
//
//  Created by carusd on 14-7-2.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTNextPageIndicatorView.h"



@interface GTPagingTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) NSInteger pageNo;
@property (nonatomic) NSInteger total;
@property (nonatomic) NSInteger pageSize;
@property (nonatomic) BOOL isLoading;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSDictionary *datas;



- (BOOL)hasNextPage;
- (void)loadDataWithPage:(NSInteger)index;
- (void)handleLoadedData:(NSDictionary *)data;
- (void)handleLoadedError:(NSError *)e;
- (void)refresh;

- (UIView *)customTableFooterView;
- (GTNextPageIndicatorView *)nextPageIndicatorView;
@end
