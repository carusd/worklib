//
//  GTWebviewController.m
//  iGuitar
//
//  Created by carusd on 14-7-9.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "GTWebviewController.h"

@interface GTWebviewController ()

@end

@implementation GTWebviewController

- (id)initWithExt:(NSDictionary *)ext {
    self = [super init];
    if (self) {
        _ext = ext;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (GTIOSVersion >= 7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    self.webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, GTNavigationBarHeight(), GTDeviceWidth, GTDeviceHeight - GTNavigationBarHeight())];
    self.webview.translatesAutoresizingMaskIntoConstraints = NO;
    self.webview.delegate = self;
    [self.view addSubview:self.webview];
    
    [self.view sendSubviewToBack:self.webview];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_webview);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_webview]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_webview]|" options:0 metrics:nil views:views]];
    
    
    if (_ext) {
        NSString *url = _ext[@"url"];
        
        self.navigationItem.title = _ext[@"title"];
        
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

@end
