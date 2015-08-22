//
//  GTImageView.m
//  iGuitar
//
//  Created by carusd on 14-6-4.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "GTImageView.h"
#import "AFNetworking.h"

@implementation GTImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"image/jpeg"];
    [manager GET:imageUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject  %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fffffffffffffff %@", error);
    }];
}

@end
