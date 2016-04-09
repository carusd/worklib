//
//  GTPickImageViewController.h
//  worklib
//
//  Created by carusd on 16/4/1.
//  Copyright © 2016年 carusd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface GTPickImageViewController : UIViewController

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) PHAssetCollection *assetCollection;

@end
