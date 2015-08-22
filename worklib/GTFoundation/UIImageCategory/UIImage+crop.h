//
//  UIImage+crop.h
//  iGuitar
//
//  Created by carusd on 15/8/18.
//  Copyright (c) 2015年 GuitarGG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (crop)

- (UIImage *)imageWithCropRect:(CGRect)outputRect;

@end
