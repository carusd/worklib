//
//  GTSinaEntity.m
//  iGuitar
//
//  Created by carusd on 14/12/1.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#import "GTSinaEntity.h"
#import "NSFileManager+AppRef.h"

@implementation GTSinaEntity

static GTSinaEntity *_sinaEntity = nil;

+ (instancetype)sinaEntityWithUMSinaEntity:(UMSocialAccountEntity *)sinaEntity {
    GTSinaEntity *entity = [GTSinaEntity new];
    entity.userName = sinaEntity.userName;
    entity.usid = sinaEntity.usid;
    entity.iconURL = sinaEntity.iconURL;
    entity.accessToken = sinaEntity.accessToken;
    entity.profileURL = sinaEntity.profileURL;
    entity.expirationDate = sinaEntity.expirationDate;
    
    return entity;
}

+ (instancetype)sinaEntityBinded {
    if (!_sinaEntity) {
        NSString *filename = @"sinaEntity";
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", [NSFileManager documentDirectoryPath], filename];
        
        _sinaEntity = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    
    
    return _sinaEntity;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.usid = [aDecoder decodeObjectForKey:@"usid"];
        self.iconURL = [aDecoder decodeObjectForKey:@"iconURL"];
        self.accessToken = [aDecoder decodeObjectForKey:@"accessToken"];
        self.profileURL = [aDecoder decodeObjectForKey:@"profileURL"];;
        self.expirationDate = [aDecoder decodeObjectForKey:@"expirationDate"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.usid forKey:@"usid"];
    [aCoder encodeObject:self.iconURL forKey:@"iconURL"];
    [aCoder encodeObject:self.accessToken forKey:@"accessToken"];
    [aCoder encodeObject:self.profileURL forKey:@"profileURL"];
    [aCoder encodeObject:self.expirationDate forKey:@"expirationDate"];
}


+ (BOOL)isBinded {
    GTSinaEntity *sinaEntity = [GTSinaEntity sinaEntityBinded];
    if (sinaEntity) {
        return [sinaEntity.expirationDate compare:[NSDate date]] == NSOrderedDescending;
    } else {
        return NO;
    }
    
}

+ (void)bind:(GTSinaEntity *)sinaEntity {
    
    NSData *sinaData = [NSKeyedArchiver archivedDataWithRootObject:sinaEntity];
    
    NSString *filename = @"sinaEntity";
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", [NSFileManager documentDirectoryPath], filename];
    [sinaData writeToFile:filePath atomically:YES];
    
    
}

+ (void)unbind {
    NSString *filename = @"sinaEntity";
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", [NSFileManager documentDirectoryPath], filename];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    
    _sinaEntity = nil;
}

@end
