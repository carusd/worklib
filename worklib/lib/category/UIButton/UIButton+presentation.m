//
//  UIButton+presentation.m
//  yueai
//
//  Created by carusd on 16/5/4.
//  Copyright © 2016年 nineox. All rights reserved.
//

#import "UIButton+presentation.h"

@implementation UIButton (presentation)

- (void)setUpdown {
    CGFloat spacing = 6.0;
    
    CGSize imageSize = self.imageView.frame.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0);
    
    CGSize titleSize = self.titleLabel.frame.size;
    self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
}

- (void)setSpace:(CGFloat)space {
//    self.contentEdgeInsets = UIEdgeInsetsMake(0, -space / 2, 0, -space / 2);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -space / 2);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -space / 2, 0, 0);
}

@end
