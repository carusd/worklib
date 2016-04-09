//
//  GTPickImageViewController.m
//  worklib
//
//  Created by carusd on 16/4/1.
//  Copyright © 2016年 carusd. All rights reserved.
//

#import "GTPickImageViewController.h"
#import "GTPickImageCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIViewController+common.h"
#import "GTConstants.h"

@interface GTImageInfo : NSObject

@property (nonatomic, strong) UIImage *image;

@end

@implementation GTImageInfo



@end

@interface GTPickImageViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic) CGFloat sizeLength;

@end

@implementation GTPickImageViewController

- (void)viewDidLoad {
    
    self.sizeLength = (GTDeviceWidth - 20) / 3;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.collectionView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_collectionView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]|" options:0 metrics:nil views:views]];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GTPickImageCell" bundle:nil] forCellWithReuseIdentifier:@"GTPickImageCell"];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self setupLoadingView];
    
    [self loadImages];
}

- (void)loadImages {
    self.images = [NSMutableArray array];
    if (GTIOSVersion >= 8) {
        [self showLoading];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:self.assetCollection options:nil];
            for (NSInteger i=0; i<result.count; i++) {
                PHAsset *asset = [result objectAtIndex:i];
                
                PHImageRequestOptions *options = [PHImageRequestOptions new];
                options.synchronous = YES;
                
//                CGFloat scale = [UIScreen mainScreen].scale;
                CGFloat scale = 1;
                CGSize imagePreviewSize = CGSizeMake(scale * self.sizeLength, scale * self.sizeLength);
                
                GTImageInfo *imageInfo = [GTImageInfo new];
                
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imagePreviewSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *image, NSDictionary *info) {
                    imageInfo.image = image;
                }];
                
                [self.images addObject:imageInfo];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideLoading];
                [self.collectionView reloadData];
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:result.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            });
        });
        
    } else {
        [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL *stop) {
            GTImageInfo *imageInfo = [GTImageInfo new];
            
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            CGImageRef imageRef = [representation fullScreenImage];
            NSLog(@"image preview size %@", NSStringFromCGSize(CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef))));
            
            UIImage *image = [UIImage imageWithCGImage:imageRef];
            imageInfo.image = image;
            
        }];
    }
}


#pragma mark - collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GTPickImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GTPickImageCell" forIndexPath:indexPath];
    GTImageInfo *imageInfo = self.images[indexPath.item];
    
    
    cell.imagePreview.image = imageInfo.image;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat a = (GTDeviceWidth - 20) / 3;
    return CGSizeMake(a, a);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}


@end
