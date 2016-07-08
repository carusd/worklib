//
//  UIView+notification.h
//  Pods
//
//  Created by carusd on 16/6/4.
//
//

#import <UIKit/UIKit.h>

@interface UIView (notification)

- (void)showNotification;
- (void)hideNotification;
- (BOOL)showingNotification;
- (void)setNotificationPosition:(CGPoint)point;
@end
