//
//  GTWebviewController.h
//  iGuitar
//
//  Created by carusd on 14-7-9.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTWebviewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webview;

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, copy) NSString *titleText;


@end
