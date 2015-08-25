//
//  GTPagingTableViewController.m
//  iGuitar
//
//  Created by carusd on 14-7-2.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "GTPagingTableViewController.h"


@interface GTTableView : UITableView


@end

@implementation GTTableView

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
}

@end

@interface GTPagingTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) GTNextPageIndicatorView *nextPageIndicatorView;

@property (nonatomic, strong) NSLayoutConstraint *top4Refresh;

@end

@implementation GTPagingTableViewController
@synthesize tableView = _tableView;
@synthesize dataArray = _dataArray;

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
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = GTColor(105, 92, 82, 1);
    
    self.nextPageIndicatorView = [[GTNextPageIndicatorView alloc] init];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    if (GTIOSVersion >= 7) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
    
    
    [self.view addSubview:self.tableView];
    
    NSMutableArray *constraints = [NSMutableArray array];
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableView);
    
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:views];
    NSArray *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:horizontal];
    [self.view addConstraints:vertical];
    
    [constraints addObjectsFromArray:horizontal];
    [constraints addObjectsFromArray:vertical];
    
    self.constraints4TableView = constraints;
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
- (void)reload {
    [self reloadData];
}

- (void)hide {
    [UIView animateWithDuration:.2 animations:^{
        
        self.tableView.contentInset = UIEdgeInsetsZero;
    }];
    
}

@end
