//
//  GTPagingTableViewController.m
//  iGuitar
//
//  Created by carusd on 14-7-2.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "GTPagingTableViewController.h"

@interface GTPagingTableViewController ()

//@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) GTNextPageIndicatorView *nextPageIndicatorView;

@property (nonatomic, strong) NSLayoutConstraint *top4Refresh;

@end

@implementation GTPagingTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nextPageIndicatorView = [[GTNextPageIndicatorView alloc] init];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    if (GTIOSVersion >= 7) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
    
    
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
    [self handleLoadedData:dic dataSourceType:GTPagingDataSourceTypeNetwork];
}

- (UIView *)customTableFooterView {
    return nil;
}

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

//- (GTNextPageIndicatorView *)nextPageIndicatorView {
//    if (!self.tableView.tableFooterView) {
//        return [[GTNextPageIndicatorView alloc] init];
//    }
//    return (GTNextPageIndicatorView *)self.tableView.tableFooterView;
//}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
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
//        GTNextPageIndicatorView *loadNextPageLabel = (GTNextPageIndicatorView *)self.tableView.tableFooterView;
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
