//
//  NSDictionary+urlParams.m
//  Pods
//
//  Created by carusd on 16/7/2.
//
//

#import "NSDictionary+urlParams.h"
#import "NSString+uriencode.h"

@implementation NSDictionary (urlParams)

+ (NSDictionary *)httpParametersWithUri:(NSString *)uri
{
    NSRange pos = [uri rangeOfString:@"?"];
    if (pos.location == NSNotFound)
        return @{};
    
    return [NSDictionary httpParametersWithFormEncodedData:[uri substringFromIndex:pos.location + 1]];
}

+ (NSDictionary *)httpParametersWithFormEncodedData:(NSString *)formData
{
    NSArray *params = [formData componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (NSString * param in params) {
        NSArray *pv = [param componentsSeparatedByString:@"="];
        NSString *v = @"";
        if ([pv count] == 2)
            v = [[pv objectAtIndex:1] decodeURIComponent];
        [result setObject:v forKey:[pv objectAtIndex:0]];
    }
    
    return result;
}

+ (NSDictionary *)httpParametersWithFormData:(NSString *)formData
{
    NSArray *params = [formData componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (NSString * param in params) {
        NSArray *pv = [param componentsSeparatedByString:@"="];
        NSString *v = @"";
        if ([pv count] == 2)
            v = [pv objectAtIndex:1];
        [result setObject:v forKey:[pv objectAtIndex:0]];
    }
    
    return result;
}
@end
