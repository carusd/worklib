//
//  GTAlbumsViewController.m
//  worklib
//
//  Created by carusd on 16/4/5.
//  Copyright © 2016年 carusd. All rights reserved.
//

#import "GTAlbumsViewController.h"
#import "GTAlbumCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface GTAlbumsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *albums;

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@end

@implementation GTAlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 44, 44);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.rightBarButtonItems = @[rightBarBtn];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    NSBundle *worklibBundle = [NSBundle bundleForClass:[GTAlbumsViewController class]];
    NSLog(@"all bundles %@", [NSBundle allBundles]);
    NSLog(@"worklib bundle %@", worklibBundle);
    [self.tableView registerNib:[UINib nibWithNibName:@"GTAlbumCell" bundle:worklibBundle] forCellReuseIdentifier:@"GTAlbumCell"];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:views]];
    
    
    [self loadAlbums];
}

- (void)loadAlbums {
    self.albums = [NSMutableArray array];
    
    __weak GTAlbumsViewController *wSelf = self;
    
    self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *assetsGroup, BOOL *stop) {
        if (assetsGroup.numberOfAssets > 0)
        {
            [wSelf.albums addObject:assetsGroup];
        }
        
        [wSelf.tableView reloadData];
    }failureBlock:^(NSError *e) {
        NSLog(@"something wrong %@", e);
    }];
}

#pragma mark tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GTAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GTAlbumCell" forIndexPath:indexPath];
    
    ALAssetsGroup *album = self.albums[indexPath.row];
    
    NSString *albumName = [album valueForKey:ALAssetsGroupPropertyName];
    
    cell.thumbImageView.image = [UIImage imageWithCGImage:album.posterImage];
    cell.albumName.text = albumName;
    cell.imageCount.text = @(album.numberOfAssets).stringValue;
    
    return cell;
}

@end
