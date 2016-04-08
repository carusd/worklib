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

@interface GTPickImageViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *assetsGroups;
@property (nonatomic, strong) NSMutableArray *allAssetsArray;
@property (nonatomic, strong) NSMutableArray *assetsArray;

@end

@implementation GTPickImageViewController

- (void)viewDidLoad {
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
    [self.view addSubview:self.collectionView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_collectionView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]|" options:0 metrics:nil views:views]];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GTPickImageCell" bundle:nil] forCellWithReuseIdentifier:@"GTPickImageCell"];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [super viewDidLoad];
    
}


#pragma mark - collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.assetsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GTPickImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GTPickImageCell" forIndexPath:indexPath];
    ALAsset *asset = self.assetsArray[indexPath.row];
    CGImageRef imageRef = [asset aspectRatioThumbnail];
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    
    cell.imagePreview.image = image;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat a = (GTDeviceWidth - 20) / 3;
    return CGSizeMake(a, a);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


@end
