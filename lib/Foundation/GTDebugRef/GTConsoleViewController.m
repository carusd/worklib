//
//  GTConsoleViewController.m
//  iGuitar
//
//  Created by carusd on 14-8-28.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "GTConsoleViewController.h"

@interface GTConsoleViewController ()
@property (nonatomic, strong) UITextView *textView;
@end

@implementation GTConsoleViewController

+ (void)startup {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logInfo = [[NSMutableString alloc] init];
    });
}

NSMutableString *logInfo = nil;

- (void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.textView = [[UITextView alloc] init];
    self.textView.frame = CGRectMake(0, 20, GTDeviceWidth, GTValue(460, 548));
    self.textView.backgroundColor = [UIColor blackColor];
    self.textView.textColor = [UIColor greenColor];
    self.textView.editable = NO;
    
    [self.view addSubview:self.textView];
    
    UISwipeGestureRecognizer *closeMe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeMe)];
    closeMe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:closeMe];
    
    
    self.textView.text = logInfo;
    @try {
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length - 1, 1)];
    }
    @catch (NSException *exception) {
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)closeMe {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
