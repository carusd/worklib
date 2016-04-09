//
//  GTDebugViewController.m
//  iGuitar
//
//  Created by carusd on 14-8-28.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "GTDebugViewController.h"
#import "GTMaskView.h"

@interface GTDebugViewController ()

@end

@implementation GTDebugViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"退出" forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 300, 100, 100);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    backButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:backButton];
    
    UIButton *testCollectionMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    [testCollectionMenu setTitle:@"testCollectionMenu" forState:UIControlStateNormal];
    testCollectionMenu.frame = CGRectMake(100, 0, 100, 100);
    [testCollectionMenu addTarget:self action:@selector(testCollectionMenu) forControlEvents:UIControlEventTouchUpInside];
    testCollectionMenu.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:testCollectionMenu];
    
    
    UIButton *testDispatchSource = [UIButton buttonWithType:UIButtonTypeCustom];
    [testDispatchSource setTitle:@"dispatchsource" forState:UIControlStateNormal];
    testDispatchSource.frame = CGRectMake(200, 0, 100, 100);
    [testDispatchSource addTarget:self action:@selector(testDispatchSource) forControlEvents:UIControlEventTouchUpInside];
    testDispatchSource.backgroundColor = [UIColor redColor];
    [self.view addSubview:testDispatchSource];
    
    
    UIButton *testMainQueue = [UIButton buttonWithType:UIButtonTypeCustom];
    [testMainQueue setTitle:@"testMainQueue" forState:UIControlStateNormal];
    testMainQueue.frame = CGRectMake(0, 0, 100, 100);
    [testMainQueue addTarget:self action:@selector(testMainQueue) forControlEvents:UIControlEventTouchUpInside];
    testMainQueue.backgroundColor = [UIColor redColor];
    [self.view addSubview:testMainQueue];
    
    UIButton *testing = [UIButton buttonWithType:UIButtonTypeCustom];
    [testing setTitle:@"testing" forState:UIControlStateNormal];
    testing.frame = CGRectMake(0, 100, 100, 100);
    [testing addTarget:self action:@selector(testing) forControlEvents:UIControlEventTouchUpInside];
    testing.backgroundColor = [UIColor redColor];
    [self.view addSubview:testing];
}

- (void)testing {
}



- (void)testMainQueue {

}

- (void)testDispatchSource {
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD,
                                                      0, 0, q);
    dispatch_source_set_event_handler(source, ^{
        // Get some data from the source variable, which is captured
        // from the parent context.
        size_t estimated = dispatch_source_get_data(source);
        NSLog(@"eeeeeeeeeeeeeee  %zu", estimated);
        NSLog(@"ddddddddd  %d", [NSThread isMainThread]);
        // Continue reading the descriptor...
    });
    dispatch_resume(source);
    
    dispatch_async(q, ^{
        dispatch_source_merge_data(source, 1);
        dispatch_source_merge_data(source, 1);
        dispatch_source_merge_data(source, 1);
        dispatch_source_merge_data(source, 1);
        dispatch_source_merge_data(source, 10);
    });
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        dispatch_source_merge_data(source, 1);
//    });
    dispatch_async(q, ^{
        dispatch_source_merge_data(source, 1);
    });
    
    
//    [GTDBManager executeUpdate:@"create table if not exists testing (id integer primary key autoincrement, z text);"];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//        [GTDBManager executeBlock:^(BOOL result) {
//            NSLog(@"result %d", result);
//        }afterUpdate:@"insert into testing (z) values ('ggg')"];
//        [GTDBManager executeBlock:^(BOOL result) {
//            NSLog(@"result %d", result);
//        }afterUpdate:@"insert into testing (z) values ('111')"];
//        [GTDBManager executeBlock:^(BOOL result) {
//            NSLog(@"result %d", result);
//        }afterUpdate:@"insert into testing (z) values ('111')"];
//        [GTDBManager executeBlock:^(BOOL result) {
//            NSLog(@"result %d", result);
//        }afterUpdate:@"insert into testing (z) values ('222')"];
//        [GTDBManager executeBlock:^(BOOL result) {
//            NSLog(@"result %d", result);
//        }afterUpdate:@"insert into testing (z) values ('333')"];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [GTDBManager executeBlock:^(NSDictionary *result) {
//                NSLog(@"rrrrrrrrrrr %@", result);
//            }afterQuerySingleObject:@"select * from testing where z = '222'"];
//            
//            [GTDBManager executeUpdate:@"insert into testing (z) values ('ggg')"];
//            [GTDBManager executeBlock:^(NSDictionary *result) {
//                NSLog(@"rrrrrrrrrrr %@", result);
//            }afterQuerySingleObject:@"select * from testing where z = '222'"];
//            
//            [GTDBManager executeUpdate:@"insert into testing (z) values ('ggg')"];
//            [GTDBManager executeBlock:^(NSDictionary *result) {
//                NSLog(@"rrrrrrrrrrr %@", result);
//            }afterQuerySingleObject:@"select * from testing where z = '222'"];
//            
//            [GTDBManager executeUpdate:@"insert into testing (z) values ('222')"];
//            [GTDBManager executeBlock:^(NSDictionary *result) {
//                NSLog(@"rrrrrrrrrrr %@", result);
//            }afterQuerySingleObject:@"select * from testing where z = '222'"];
//            
//            [GTDBManager executeUpdate:@"insert into testing (z) values ('222')"];
//            [GTDBManager executeBlock:^(NSDictionary *result) {
//                NSLog(@"rrrrrrrrrrr %@", result);
//            }afterQuerySingleObject:@"select * from testing where z = '222'"];
//            
//            [GTDBManager executeUpdate:@"insert into testing (z) values ('222')"];
//            [GTDBManager executeBlock:^(NSDictionary *result) {
//                NSLog(@"rrrrrrrrrrr %@", result);
//            }afterQuerySingleObject:@"select * from testing where z = '222'"];
//            
//            [GTDBManager executeUpdate:@"insert into testing (z) values ('222')"];
//            
//            [GTDBManager executeBlock:^(NSArray *result) {
//                NSLog(@"jjjjjjjjjjj  %@", result);
//            }afterQueryList:@"select * from testing where z = '222'"];
//        });
//    });
    
}


- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
