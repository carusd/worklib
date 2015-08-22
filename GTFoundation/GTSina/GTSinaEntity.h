//
//  GTSinaEntity.h
//  iGuitar
//
//  Created by carusd on 14/12/1.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocial.h"

@interface GTSinaEntity : NSObject <NSCoding>

/**
 用户昵称
 */
@property (nonatomic, copy) NSString *userName;

/**
 用户在微博的id号
 */
@property (nonatomic, copy) NSString *usid;

/**
 用户微博头像的url
 */
@property (nonatomic, copy) NSString *iconURL;

/**
 用户授权后得到的accessToken
 */
@property (nonatomic, copy) NSString *accessToken;

/**
 用户微博网址url
 */
@property (nonatomic, copy) NSString *profileURL;

/**
 授权的过期时间
 */
@property (nonatomic, retain) NSDate *expirationDate;



+ (instancetype)sinaEntityBinded;
+ (instancetype)sinaEntityWithUMSinaEntity:(UMSocialAccountEntity *)sinaEntity;

+ (BOOL)isBinded;

+ (void)bind:(GTSinaEntity *)sinaEntity;
+ (void)unbind;
@end
