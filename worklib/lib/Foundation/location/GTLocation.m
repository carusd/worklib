//
//  GTLocation.m
//  iGuitar
//
//  Created by carusd on 15/10/12.
//  Copyright (c) 2015年 GuitarGG. All rights reserved.
//

#import "GTLocation.h"
#import <UIKit/UIKit.h>

NSString * const GTLocationResultNotif = @"GTLocationResultNotif";

@interface GTLocation ()

@property (nonatomic) BOOL ready;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation GTLocation

+ (instancetype)sharedInstance {
    static GTLocation *location = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        location = [[GTLocation alloc] init];
    });
    
    return location;
}

- (void)startUp {
    [self getLocation];
}

- (void)getLocation {
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"模拟位置中");
    //    block(113.388953, 23.133900,nil);
    _longitude = 113.388953;
    _latitude = 23.133900;
    
    _province = @"广东省";
    _city = @"广州市";
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GTLocationResultNotif object:nil];
#else
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        [self.locationManager startUpdatingLocation];
    } else {
        
    }
#endif
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"抱歉" message:@"无法获取您的位置信息，您可以在【设置】-【隐私】-【定位服务】中开启定位服务" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:cancelAction];
    
    UIAlertAction *toSetting = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:UIApplicationOpenSettingsURLString];
    }];
    [alertController addAction:toSetting];
    
    UIViewController *rootViewController = [[[UIApplication sharedApplication] windows].firstObject rootViewController];
    [rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    
    CLLocation *lastLocation = locations.lastObject;
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:lastLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       for (CLPlacemark *placemark in placemarks) {
                           NSString *city = [placemark locality];
                           NSLog(@"current city %@", city);
                           NSLog(@"administrativeArea %@", placemark.administrativeArea);
                           NSLog(@"subAdministrativeArea %@", placemark.subAdministrativeArea);
                           self.province = placemark.administrativeArea;
                           self.city = city;
                           
                           _longitude = lastLocation.coordinate.longitude;
                           _latitude = lastLocation.coordinate.latitude;
                           
                           _ready = YES;
                           [[NSNotificationCenter defaultCenter] postNotificationName:GTLocationResultNotif object:nil];
                       }
                   }];
    
    
}
@end
