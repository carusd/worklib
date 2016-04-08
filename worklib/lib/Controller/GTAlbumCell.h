//
//  GTAlbumCell.h
//  worklib
//
//  Created by carusd on 16/4/5.
//  Copyright © 2016年 carusd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTAlbumCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *albumName;
@property (weak, nonatomic) IBOutlet UILabel *imageCount;

@end
