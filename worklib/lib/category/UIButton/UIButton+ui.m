//
//  UIButton+ui.m
//  iGuitar
//
//  Created by carusd on 14/12/6.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "UIButton+ui.h"

@implementation UIButton (ui)

- (void)reverseImageLabelPosition {
    if (!self.imageView || !self.titleLabel) {
        return;
    }
    
    self.titleLabel.frame = CGRectMake(0, CGRectGetMinY(self.titleLabel.frame), CGRectGetWidth(self.titleLabel.frame), CGRectGetHeight(self.titleLabel.frame));
    self.imageView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), CGRectGetMinY(self.imageView.frame), CGRectGetWidth(self.imageView.frame), CGRectGetHeight(self.imageView.frame));
    
    
}

@end
