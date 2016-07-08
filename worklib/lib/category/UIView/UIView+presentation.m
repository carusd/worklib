//
//  UIView+presentation.m
//  yueai
//
//  Created by carusd on 16/5/18.
//  Copyright © 2016年 nineox. All rights reserved.
//

#import "UIView+presentation.h"

@implementation UIView (presentation)

- (void)cutWithCornerRadius:(CGFloat)radius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}



@end
