//
//  GTPickImageCell.m
//  worklib
//
//  Created by carusd on 16/4/1.
//  Copyright © 2016年 carusd. All rights reserved.
//

#import "GTPickImageCell.h"

@implementation GTPickImageCell

- (void)awakeFromNib {
    self.imagePreview.layer.masksToBounds = YES;
}

@end
