//
//  GTPagingTableViewController.m
//  iGuitar
//
//  Created by carusd on 14-7-2.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "GTPagingTableViewController.h"

@interface GTPagingTableViewController ()

@property (nonatomic, strong) GTNextPageIndicatorView *nextPageIndicatorView;


@end

@implementation GTPagingTableViewController


- (void)dealloc {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nextPageIndicatorView = [[GTNextPageIndicatorView alloc] init];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    
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

#pragma mark load data
- (void)loadDataWithPage:(NSInteger)index {
    self.isLoading = YES;
}

- (void)reloadData {
    
    self.datas = nil;
    self.dataArray = nil;
    self.isLoading = YES;
    [self loadDataWithPage:1];
}

- (void)handleLoadedError:(NSError *)e {
    
}

- (void)handleLoadedData:(NSDictionary *)dic {
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
    
    [self.tableView reloadData];
    
    if (self.hasNextPage) {
        GTNextPageIndicatorView *indicator = self.nextPageIndicatorView;
        [indicator.indicatorView stopAnimating];
        self.tableView.tableFooterView = indicator;
    } else {
        self.tableView.tableFooterView = self.customTableFooterView;
    }
    
    self.isLoading = NO;
    [self hide];
}

- (UIView *)customTableFooterView {
    return [UIView new];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


#pragma mark scroll view delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y + scrollView.frame.size.height  >= scrollView.contentSize.height && self.isLoading == NO && self.hasNextPage) {
        self.nextPageIndicatorView.text = @"正在加载";
        
        [self.nextPageIndicatorView.indicatorView startAnimating];
        [self loadDataWithPage:self.pageNo+1];
    }
}

#pragma mark refresh
- (void)refresh {
    [self reloadData];
}

- (void)hide {
    [UIView animateWithDuration:.2 animations:^{
        
        self.tableView.contentInset = UIEdgeInsetsZero;
    }];
    
}

@end
