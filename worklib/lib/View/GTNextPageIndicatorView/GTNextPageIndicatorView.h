//
//  GTNextPageIndicatorView.h
//  iGuitar
//
//  Created by carusd on 14-7-2.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GTNextPageIndicatorViewStatusNormal,
    GTNextPageIndicatorViewStatusLoading
} GTNextPageIndicatorViewStatus;

@interface GTNextPageIndicatorView : UIView

- (id)initWithNormalText:(NSString *)normalText loadingText:(NSString *)loadingText;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, copy) NSString *normalText;
@property (nonatomic, copy) NSString *loadingText;

@property (nonatomic) GTNextPageIndicatorViewStatus status;

@end
