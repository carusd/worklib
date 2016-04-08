//
//  GTAlbumCell.m
//  worklib
//
//  Created by carusd on 16/4/5.
//  Copyright © 2016年 carusd. All rights reserved.
//

#import "GTAlbumCell.h"

@implementation GTAlbumCell

- (void)awakeFromNib {
    self.thumbImageView.layer.masksToBounds = YES;
}

@end
