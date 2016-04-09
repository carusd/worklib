//
//  GTWebviewController.m
//  iGuitar
//
//  Created by carusd on 14-7-9.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "GTWebviewController.h"
#import "UIViewController+common.h"

@interface GTWebviewController ()
@property (nonatomic, strong) UIWebView *webview;
@end

@implementation GTWebviewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.webview = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.webview.translatesAutoresizingMaskIntoConstraints = NO;
    self.webview.delegate = self;
    [self.view addSubview:self.webview];
    
    [self.view sendSubviewToBack:self.webview];
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_webview);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_webview]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_webview]|" options:0 metrics:nil views:views]];
    
    [self setupLoadingView];
    
    self.navigationItem.title = self.titleText;
    
    [self showLoading];
    [self.webview loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideLoading];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

@end
