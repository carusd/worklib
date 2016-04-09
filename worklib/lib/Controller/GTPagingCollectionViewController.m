//
//  GTPagingCollectionViewController.m
//  iGuitar
//
//  Created by carusd on 15/7/16.
//  Copyright (c) 2015年 GuitarGG. All rights reserved.
//

#import "GTPagingCollectionViewController.h"
#import "GTConstants.h"

@interface GTNextPageCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) GTNextPageIndicatorView *nextPageIndicatorView;

@end

@implementation GTNextPageCollectionReusableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.nextPageIndicatorView = [[GTNextPageIndicatorView alloc] init];
    self.nextPageIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.nextPageIndicatorView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_nextPageIndicatorView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_nextPageIndicatorView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_nextPageIndicatorView]|" options:0 metrics:nil views:views]];
}

@end

@interface GTPagingCollectionViewController ()


@property (nonatomic, strong) GTNextPageIndicatorView *nextPageIndicatorView;

@property (nonatomic, strong) NSLayoutConstraint *top4Refresh;

@end

@implementation GTPagingCollectionViewController

- (void)dealloc {
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}

- (void)viewDidLoad {
    [self.collectionView registerClass:[GTNextPageCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"GTNextPageCollectionReusableView"];
    
    [super viewDidLoad];
    
}

- (UIView *)customTableFooterView {
    return [UIView new];
}

#pragma mark load data
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
    
    [self.collectionView reloadData];
    self.nextPageIndicatorView.status = GTNextPageIndicatorViewStatusNormal;
    
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

- (void)handleLoadedError:(NSError *)e {
    
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
- (void)refresh {
    [self reloadData];
}

- (void)hide {
    [UIView animateWithDuration:.2 animations:^{
        
        self.collectionView.contentInset = UIEdgeInsetsZero;
    }];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    GTNextPageCollectionReusableView *nextPageView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"GTNextPageCollectionReusableView" forIndexPath:indexPath];
    self.nextPageIndicatorView = nextPageView.nextPageIndicatorView;
    
    
    return nextPageView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (self.hasNextPage) {
        return CGSizeMake(GTDeviceWidth, 44);
    } else {
        return CGSizeMake(GTDeviceWidth, 0);
    }
    
}


#pragma mark scroll view delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y + scrollView.frame.size.height  >= scrollView.contentSize.height && self.isLoading == NO && self.hasNextPage) {
        self.nextPageIndicatorView.status = GTNextPageIndicatorViewStatusLoading;
        
        [self.nextPageIndicatorView.indicatorView startAnimating];
        [self loadDataWithPage:self.pageNo+1];
    }
}
@end
