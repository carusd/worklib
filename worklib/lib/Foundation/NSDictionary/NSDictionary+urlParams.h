//
//  NSDictionary+urlParams.h
//  Pods
//
//  Created by carusd on 16/7/2.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (urlParams)

+ (NSDictionary *)httpParametersWithUri:(NSString *)uri;
+ (NSDictionary *)httpParametersWithFormEncodedData:(NSString *)formData;
+ (NSDictionary *)httpParametersWithFormData:(NSString *)formData;

@end
