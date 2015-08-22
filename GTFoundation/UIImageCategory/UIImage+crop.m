//
//  UIImage+crop.m
//  iGuitar
//
//  Created by carusd on 15/8/18.
//  Copyright (c) 2015年 GuitarGG. All rights reserved.
//

#import "UIImage+crop.h"

@implementation UIImage (crop)

- (UIImage *)imageWithCropRect:(CGRect)outputRect {
    CGImageRef takenCGImage = self.CGImage;
    size_t width = CGImageGetWidth(takenCGImage);
    size_t height = CGImageGetHeight(takenCGImage);
    CGRect cropRect = CGRectMake(outputRect.origin.x * width, outputRect.origin.y * height, outputRect.size.width * width, outputRect.size.height * height);
    
    
    CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);
    UIImage *resultImage = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:self.imageOrientation];
    CGImageRelease(cropCGImage);
    
    return resultImage;
}

@end
