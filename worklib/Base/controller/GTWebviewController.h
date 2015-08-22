//
//  GTWebviewController.h
//  iGuitar
//
//  Created by carusd on 14-7-9.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "GTViewController.h"

@interface GTWebviewController : GTViewController<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webview;

- (id)initWithExt:(NSDictionary *)ext;


@end
