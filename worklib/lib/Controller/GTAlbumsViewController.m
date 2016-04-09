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
#import <Photos/Photos.h>
#import "GTPickImageViewController.h"
#import "UIViewController+common.h"
#import "GTConstants.h"

@interface GTAlbumInfo : NSObject

@property (nonatomic, strong) UIImage *posterImage;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) NSInteger imageCount;

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) PHAssetCollection *assetCollection;

@end

@implementation GTAlbumInfo



@end

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
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.rightBarButtonItems = @[rightBarBtn];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    NSBundle *worklibBundle = [NSBundle bundleForClass:[GTAlbumsViewController class]];
    [self.tableView registerNib:[UINib nibWithNibName:@"GTAlbumCell" bundle:worklibBundle] forCellReuseIdentifier:@"GTAlbumCell"];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.rowHeight = 57;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:views]];
    
    [self setupLoadingView];
    
    [self loadAlbums];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 typedef NS_ENUM(NSInteger, PHAssetCollectionSubtype) {
 
 // PHAssetCollectionTypeAlbum regular subtypes
 PHAssetCollectionSubtypeAlbumRegular         = 2,
 PHAssetCollectionSubtypeAlbumSyncedEvent     = 3,
 PHAssetCollectionSubtypeAlbumSyncedFaces     = 4,
 PHAssetCollectionSubtypeAlbumSyncedAlbum     = 5,
 PHAssetCollectionSubtypeAlbumImported        = 6,
 
 // PHAssetCollectionTypeAlbum shared subtypes
 PHAssetCollectionSubtypeAlbumMyPhotoStream   = 100,
 PHAssetCollectionSubtypeAlbumCloudShared     = 101,
 
 // PHAssetCollectionTypeSmartAlbum subtypes
 PHAssetCollectionSubtypeSmartAlbumGeneric    = 200,  nothing
 PHAssetCollectionSubtypeSmartAlbumPanoramas  = 201, 全景照片
 PHAssetCollectionSubtypeSmartAlbumVideos     = 202,
 PHAssetCollectionSubtypeSmartAlbumFavorites  = 203, 个人收藏
 PHAssetCollectionSubtypeSmartAlbumTimelapses = 204, 延时摄影
 PHAssetCollectionSubtypeSmartAlbumAllHidden  = 205, 已隐藏
 PHAssetCollectionSubtypeSmartAlbumRecentlyAdded = 206, 最近添加
 PHAssetCollectionSubtypeSmartAlbumBursts     = 207, 连拍快照
 PHAssetCollectionSubtypeSmartAlbumSlomoVideos = 208, 慢动作
 PHAssetCollectionSubtypeSmartAlbumUserLibrary = 209, 相机胶卷
 PHAssetCollectionSubtypeSmartAlbumSelfPortraits NS_AVAILABLE_IOS(9_0) = 210, 自拍
 PHAssetCollectionSubtypeSmartAlbumScreenshots NS_AVAILABLE_IOS(9_0) = 211, 屏幕快照
 
 // Used for fetching, if you don't care about the exact subtype
 PHAssetCollectionSubtypeAny = NSIntegerMax
 } NS_ENUM_AVAILABLE_IOS(8_0);
 */

- (void)loadAlbums {
    self.albums = [NSMutableArray array];
    
    if (GTIOSVersion >= 8) {
//        self.fetchingGroup = dispatch_group_create();
//        dispatch_group_notify(self.fetchingGroup, dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//        });
        [self showLoading];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            CGFloat scale = [UIScreen mainScreen].scale;
            CGSize requestImageSize = CGSizeMake(self.tableView.rowHeight * scale, self.tableView.rowHeight * scale);
            
            PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
            for (NSInteger i=0; i < result.count; i++) {
                PHAssetCollection *collection = [result objectAtIndex:i];
                PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                if (assetResult.count > 0) {
                    GTAlbumInfo *albumInfo = [GTAlbumInfo new];
                    albumInfo.imageCount = assetResult.count;
                    albumInfo.title = collection.localizedTitle;
                    albumInfo.assetCollection = collection;
                    PHAsset *posterAsset = [assetResult objectAtIndex:0];
                    PHImageRequestOptions *options = [PHImageRequestOptions new];
                    options.synchronous = YES;
                    
                    void (^handler)(UIImage *, NSDictionary *) = ^(UIImage *image, NSDictionary *info) {
                        albumInfo.posterImage = image;
                    };
                    
                    
                    [[PHImageManager defaultManager] requestImageForAsset:posterAsset targetSize:requestImageSize contentMode:PHImageContentModeAspectFill options:options resultHandler:handler];
                    [self.albums addObject:albumInfo];
                }
            }
            result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
            for (NSInteger i=0; i < result.count; i++) {
                PHAssetCollection *collection = [result objectAtIndex:i];
                PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                if (assetResult.count > 0) {
                    GTAlbumInfo *albumInfo = [GTAlbumInfo new];
                    albumInfo.imageCount = assetResult.count;
                    albumInfo.title = collection.localizedTitle;
                    albumInfo.assetCollection = collection;
                    PHAsset *posterAsset = [assetResult objectAtIndex:0];
                    PHImageRequestOptions *options = [PHImageRequestOptions new];
                    options.synchronous = YES;
                    
                    void (^handler)(UIImage *, NSDictionary *) = ^(UIImage *image, NSDictionary *info) {
                        albumInfo.posterImage = image;
                    };
                    
                    
                    [[PHImageManager defaultManager] requestImageForAsset:posterAsset targetSize:requestImageSize contentMode:PHImageContentModeAspectFill options:options resultHandler:handler];
                    [self.albums addObject:albumInfo];
                }
            }
            result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumPanoramas options:nil];
            for (NSInteger i=0; i < result.count; i++) {
                PHAssetCollection *collection = [result objectAtIndex:i];
                PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                if (assetResult.count > 0) {
                    GTAlbumInfo *albumInfo = [GTAlbumInfo new];
                    albumInfo.imageCount = assetResult.count;
                    albumInfo.title = collection.localizedTitle;
                    albumInfo.assetCollection = collection;
                    PHAsset *posterAsset = [assetResult objectAtIndex:0];
                    PHImageRequestOptions *options = [PHImageRequestOptions new];
                    options.synchronous = YES;
                    
                    void (^handler)(UIImage *, NSDictionary *) = ^(UIImage *image, NSDictionary *info) {
                        albumInfo.posterImage = image;
                    };
                    
                    
                    [[PHImageManager defaultManager] requestImageForAsset:posterAsset targetSize:requestImageSize contentMode:PHImageContentModeAspectFill options:options resultHandler:handler];
                    [self.albums addObject:albumInfo];
                }
            }
            result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumRecentlyAdded options:nil];
            for (NSInteger i=0; i < result.count; i++) {
                PHAssetCollection *collection = [result objectAtIndex:i];
                PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                if (assetResult.count > 0) {
                    GTAlbumInfo *albumInfo = [GTAlbumInfo new];
                    albumInfo.imageCount = assetResult.count;
                    albumInfo.title = collection.localizedTitle;
                    albumInfo.assetCollection = collection;
                    PHAsset *posterAsset = [assetResult objectAtIndex:0];
                    PHImageRequestOptions *options = [PHImageRequestOptions new];
                    options.synchronous = YES;
                    
                    void (^handler)(UIImage *, NSDictionary *) = ^(UIImage *image, NSDictionary *info) {
                        albumInfo.posterImage = image;
                    };
                    
                    
                    [[PHImageManager defaultManager] requestImageForAsset:posterAsset targetSize:requestImageSize contentMode:PHImageContentModeAspectFill options:options resultHandler:handler];
                    [self.albums addObject:albumInfo];
                }
            }
            result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumBursts options:nil];
            for (NSInteger i=0; i < result.count; i++) {
                PHAssetCollection *collection = [result objectAtIndex:i];
                PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                if (assetResult.count > 0) {
                    GTAlbumInfo *albumInfo = [GTAlbumInfo new];
                    albumInfo.imageCount = assetResult.count;
                    albumInfo.title = collection.localizedTitle;
                    albumInfo.assetCollection = collection;
                    PHAsset *posterAsset = [assetResult objectAtIndex:0];
                    PHImageRequestOptions *options = [PHImageRequestOptions new];
                    options.synchronous = YES;
                    
                    void (^handler)(UIImage *, NSDictionary *) = ^(UIImage *image, NSDictionary *info) {
                        albumInfo.posterImage = image;
                    };
                    
                    
                    [[PHImageManager defaultManager] requestImageForAsset:posterAsset targetSize:requestImageSize contentMode:PHImageContentModeAspectFill options:options resultHandler:handler];
                    [self.albums addObject:albumInfo];
                }
            }
            
            if (GTIOSVersion >= 9) {
                result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumSelfPortraits options:nil];
                for (NSInteger i=0; i < result.count; i++) {
                    PHAssetCollection *collection = [result objectAtIndex:i];
                    PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                    if (assetResult.count > 0) {
                        GTAlbumInfo *albumInfo = [GTAlbumInfo new];
                        albumInfo.imageCount = assetResult.count;
                        albumInfo.title = collection.localizedTitle;
                        albumInfo.assetCollection = collection;
                        PHAsset *posterAsset = [assetResult objectAtIndex:0];
                        PHImageRequestOptions *options = [PHImageRequestOptions new];
                        options.synchronous = YES;
                        
                        void (^handler)(UIImage *, NSDictionary *) = ^(UIImage *image, NSDictionary *info) {
                            albumInfo.posterImage = image;
                        };
                        
                        
                        [[PHImageManager defaultManager] requestImageForAsset:posterAsset targetSize:requestImageSize contentMode:PHImageContentModeAspectFill options:options resultHandler:handler];
                        [self.albums addObject:albumInfo];
                    }
                }
                result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumScreenshots options:nil];
                for (NSInteger i=0; i < result.count; i++) {
                    PHAssetCollection *collection = [result objectAtIndex:i];
                    PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                    if (assetResult.count > 0) {
                        GTAlbumInfo *albumInfo = [GTAlbumInfo new];
                        albumInfo.imageCount = assetResult.count;
                        albumInfo.title = collection.localizedTitle;
                        albumInfo.assetCollection = collection;
                        PHAsset *posterAsset = [assetResult objectAtIndex:0];
                        PHImageRequestOptions *options = [PHImageRequestOptions new];
                        options.synchronous = YES;
                        
                        void (^handler)(UIImage *, NSDictionary *) = ^(UIImage *image, NSDictionary *info) {
                            albumInfo.posterImage = image;
                        };
                        
                        
                        [[PHImageManager defaultManager] requestImageForAsset:posterAsset targetSize:requestImageSize contentMode:PHImageContentModeAspectFill options:options resultHandler:handler];
                        [self.albums addObject:albumInfo];
                    }
                }
            }
            
            
            result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype: PHAssetCollectionSubtypeAlbumRegular options:nil];
            for (NSInteger i=0; i < result.count; i++) {
                PHAssetCollection *collection = [result objectAtIndex:i];
                PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                if (assetResult.count > 0) {
                    GTAlbumInfo *albumInfo = [GTAlbumInfo new];
                    albumInfo.imageCount = assetResult.count;
                    albumInfo.title = collection.localizedTitle;
                    albumInfo.assetCollection = collection;
                    PHAsset *posterAsset = [assetResult objectAtIndex:0];
                    PHImageRequestOptions *options = [PHImageRequestOptions new];
                    options.synchronous = YES;
                    
                    void (^handler)(UIImage *, NSDictionary *) = ^(UIImage *image, NSDictionary *info) {
                        albumInfo.posterImage = image;
                    };
                    
                    
                    [[PHImageManager defaultManager] requestImageForAsset:posterAsset targetSize:requestImageSize contentMode:PHImageContentModeAspectFill options:options resultHandler:handler];
                    [self.albums addObject:albumInfo];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self hideLoading];
            });
        });
        
    } else {
        __weak GTAlbumsViewController *wSelf = self;
        self.assetsLibrary = [[ALAssetsLibrary alloc] init];
        [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos | ALAssetsGroupPhotoStream | ALAssetsGroupAll  usingBlock:^(ALAssetsGroup *assetsGroup, BOOL *stop) {
            if (assetsGroup.numberOfAssets > 0)
            {
                GTAlbumInfo *albumInfo = [GTAlbumInfo new];
                albumInfo.title = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
                albumInfo.imageCount = assetsGroup.numberOfAssets;
                albumInfo.posterImage = [UIImage imageWithCGImage:assetsGroup.posterImage];
                albumInfo.assetsGroup = assetsGroup;
                [wSelf.albums insertObject:albumInfo atIndex:0];
            }
            
            [wSelf.tableView reloadData];
        }failureBlock:^(NSError *e) {
            NSLog(@"something wrong %@", e);
        }];
    }
    
    
}

#pragma mark tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GTAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GTAlbumCell" forIndexPath:indexPath];
    
    GTAlbumInfo *album = self.albums[indexPath.row];
    
    
    cell.thumbImageView.image = album.posterImage;
    cell.albumName.text = album.title;
    cell.imageCount.text = [NSString stringWithFormat:@"(%@)", @(album.imageCount).stringValue];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GTAlbumInfo *info = self.albums[indexPath.row];
    
    GTPickImageViewController *pickImage = [[GTPickImageViewController alloc] init];
    if (GTIOSVersion >= 8) {
        pickImage.assetCollection = info.assetCollection;
    } else {
        pickImage.assetsGroup = info.assetsGroup;
    }
    [self.navigationController pushViewController:pickImage animated:YES];
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


@end
