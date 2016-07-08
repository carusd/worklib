//
//  UIView+notification.m
//  Pods
//
//  Created by carusd on 16/6/4.
//
//

#import "UIView+notification.h"

@implementation UIView (notification)

- (void)showNotification {
    UIView *notification = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];

    notification.backgroundColor = [UIColor redColor];
    notification.layer.cornerRadius = 3;
    notification.layer.masksToBounds = YES;
    
    notification.tag = @"notification".hash;
    [self addSubview:notification];
    
    notification.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
    
}

- (void)hideNotification {
    [[self viewWithTag:@"notification".hash] removeFromSuperview];
}

- (BOOL)showingNotification {
    return [self viewWithTag:@"notification".hash] != nil;;
}

- (void)setNotificationPosition:(CGPoint)point {
    [self viewWithTag:@"notification".hash].center = point;
}

@end
